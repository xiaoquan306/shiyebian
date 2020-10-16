import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/camera/camera_bloc.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/jpeg_exif.dart';
import 'package:site_blackboard_app/utility/jpeg_helper.dart';
import 'package:site_blackboard_app/utility/orientation_helper.dart';
import 'package:site_blackboard_app/utility/request_permission.dart';
import 'package:site_blackboard_app/utility/write_hash_value.dart';
import 'package:site_blackboard_app/views/camera/camera_blackboard_widget.dart';
import 'package:site_blackboard_app/views/camera/camera_button_widget.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';
import 'package:toast/toast.dart';

class CameraPage extends StatefulWidget {
  CameraPage({this.caseId, Key key}) : super(key: key);
  final int caseId;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraBloc _bloc;
  CameraController controller;
  Location _location;
  LocationData _locationResult;
  StreamSubscription<LocationData> _locationSubscription;

  double aspectRatio = 720 / 1280;

  CaseItem _caseItem;
  BlackboardItem _blackboardItem;

  List<CameraDescription> cameras;
  DeviceOrientation _deviceOrientation;
  StreamSubscription<DeviceOrientation> subscription;
  bool isBtnUsed = true;

  //
  Duration durTime = Duration(milliseconds: 500);
  Timer timer;
  bool _firstOrientation = true;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
  AudioCache _audioCache = new AudioCache(respectSilence: true);

  @override
  void dispose() {
    _stopListen();

    _bloc.dispose();

    timer?.cancel();

    cameras.clear();
    cameras = null;
    _deviceOrientation = DeviceOrientation.portraitUp;
    subscription?.cancel();
    subscription?.resume();
    controller?.dispose();
    subscription = null;
    controller = null;
    OrientationHelper.initialStatic();

    super.dispose();
  }

  @override
  void initState() {
    _bloc = CameraBloc();
    _bloc.getCaseById(widget.caseId);

    _camera();
    _position();
    super.initState();
  }

  /// If the location information cannot be obtained within 3 seconds, null is returned
  Future<LocationData> _waitingLocation() async {
    if (_location == null) {
      return null;
    }

    int step = 0;

    while (true) {
      if (_locationResult != null) {
        return _locationResult;
      }

      await Future.delayed(Duration(seconds: 1));
      step++;
      if (step >= 3) {
        break;
      }
    }

    return null;
  }

  Future<void> _listenLocation() async {
    if (_location != null) {
      return;
    }

    // 位置決めサービスをチェックする
    // check location service
    _location = Location();
    if (!await _location.requestService()) {
      alertDialog(context,
          contentText: LangCamera.locationServiceIsNotTurnedOn);
      _location = null;
      return;
    }

    // 位置決め権限をチェック
    // check location permission
    if (!await RequestPermission.request(
        Permission.location, LangCamera.requestLocationPermission)) {
      _location = null;
      return;
    }

    // 位置情報を取得する
    // get location information
    _locationResult = await _location.getLocation();

    // 監視位置変更
    // Monitoring position change
    _locationSubscription =
        _location.onLocationChanged.handleError((dynamic err) {
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      _locationResult = currentLocation;
    });
  }

  Future<void> _stopListen() async {
    _locationResult = null;
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _location = null;
  }

  // カメラ初期化
  Future _camera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras[0], ResolutionPreset.high,
          enableAudio: false);
      await controller.initialize();
      if (!mounted) return;
      setState(() {});
    }
  }

  // 回転方向を取得
  void _position() {
    subscription = OrientationHelper.onOrientationChange.listen((value) {
      if (!mounted || _deviceOrientation == value) return;

      if (_firstOrientation) {
        _firstOrientation = false;
        setState(() {
          _deviceOrientation = value;
        });
        return;
      }

      timer?.cancel();
      timer = Timer(durTime, () {
        setState(() {
          _deviceOrientation = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // スクリーンの回転を禁止します
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return StreamBuilder(
      stream: _bloc.getCaseByIdStream,
      builder: (BuildContext context, AsyncSnapshot<CaseItem> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        _caseItem = snapshot.data;

        if (_caseItem.savePosition == 1) {
          _listenLocation();
        } else {
          _stopListen();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              _caseItem.name,
              style: new TextStyle(fontSize: 25),
            ),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Container(
                width: 100,
                height: 6,
                padding: EdgeInsets.all(12),
                child: RaisedButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(6),
                  child: Text(LangCamera.settings),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  onPressed: () async {
                    await App.navigateTo(context, Routes.caseSetting,
                        params: {'caseId': _caseItem.id.toString()});
                    _bloc.getCaseById(_caseItem.id);
                  },
                ),
              ),
            ],
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            return cameras == null
                ? Container(
                    child: Center(
                      child: Text(LangCamera.loading),
                    ),
                  )
                : Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.black,
                            alignment: Alignment.center,
                            child: Transform.scale(
                              scale: 1,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: aspectRatio,
                                  child: _cameraWidget(),
                                ),
                              ),
                            ),
                            // child: _cameraWidget(),
                          ),
                        ),
                        _cameraButton(),
                      ],
                    ),
                  );
          }),
          resizeToAvoidBottomPadding: false,
        );
      },
    );
  }

  ///カメラのプレビュー処理
  Widget _cameraWidget() {
    return Stack(
      children: <Widget>[
        CameraPreview(controller),
        _caseItem.useBlackboard == 1 ? _cameraScan() : Container(),
      ],
    );
  }

  ///黒板カバー処理
  Widget _cameraScan() {
    _bloc.getBlackboardById(_caseItem.blackboardDefault);
    return RotatedBox(
      quarterTurns: _deviceOrientation == DeviceOrientation.portraitUp
          ? 0
          : (_deviceOrientation == DeviceOrientation.landscapeLeft
              ? 3
              : (_deviceOrientation == DeviceOrientation.portraitDown ? 2 : 1)),
      child: Container(
        alignment: Alignment.bottomLeft,
        color: Colors.black26,
        child: StreamBuilder(
          stream: _bloc.getBlackboardByIdStream,
          builder: (BuildContext context,
              AsyncSnapshot<BlackboardItem> snapshotBlackboard) {
            if (!snapshotBlackboard.hasData) {
              return Container();
            }
            _blackboardItem = snapshotBlackboard.data;
            return CameraBlackboardWidget(
              key: getPhotoKey,
              orientation: _deviceOrientation,
              id: _caseItem.id,
              caseName: _caseItem.name,
              blockBoardItem: _blackboardItem,
              onPress: () async {
                await App.navigateTo(context, Routes.blackboards,
                    params: {'caseId': _caseItem.id, 'fromCamera': true});
                _bloc.getCaseById(_caseItem.id);
                _bloc.getBlackboardById(_caseItem.blackboardDefault);
              },
            );
          },
        ),
      ),
    );
  }

  ///撮影ボタン処理
  Widget _cameraButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 63,
      color: Colors.black,
      child: new Container(
        width: MediaQuery.of(context).size.width,
        // margin: EdgeInsets.only(top: 20.0),
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            CameraButtonWidget(
              color: Color(0xFFFF0000),
              disableColor: Colors.grey[350],
              text: LangGlobal.back,
              orientation: _deviceOrientation,
              onPressed: isBtnUsed
                  ? () {
                      Navigator.pop(context);
                    }
                  : null,
            ),
            CameraButtonWidget(
              color: Color(0xFF518518),
              disableColor: Colors.grey,
              text: LangCamera.shoot,
              orientation: _deviceOrientation,
              onPressed: isBtnUsed
                  ? () {
                      onTakePhotoButtonPressed();
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  void onTakePhotoButtonPressed() async {
    try {
      await (await App.db).execute("BEGIN;");
      takePhoto().then((String filePath) {
        if (mounted) {
          if (filePath != null) {}
        }
      });
      await (await App.db).execute("COMMIT;");
    } catch (e) {
      await (await App.db).execute("ROLLBACK;");
      throw (e);
    }
  }

  Future<String> takePhoto() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    setState(() {
      this.isBtnUsed = false;
    });

    String filePath = "";
    try {
      if (controller.value.isTakingPicture) {
        return null;
      }
      DateTime dateTime = DateTime.now();
      String fileName = dateTime.millisecondsSinceEpoch.toString();

      ///システム設定は黒板を使って写真を撮りません
      String tmpRootPath = await App.tmpPath;
      String photoRootPath = await App.photoPath;
      String dstName;
      String tmpName;
      String dstNameSuffix;
      String dstPath;
      String dstPathSuffix;
      String tmpPath;
      String tmpCompFile;
      if (_caseItem.useBlackboard != 1) {
        if (_caseItem.tamperProof != 1) {
          await controller.takePicture('$photoRootPath/$fileName.jpg');
          await _bloc.savePhoto(_caseItem.id, null, '$fileName.jpg');
          Toast.show(LangCamera.savedSuccessfully, context);
        } else {
          dstName = '$fileName.jpg';
          dstPathSuffix = '${fileName}_${LangCamera.originalFileSuffix}.jpg';
          tmpPath = '$tmpRootPath/$dstName';
          dstPath = '$photoRootPath/$dstName';
          await controller.takePicture(tmpPath);
          writeHashValue(tmpPath, dstPath);
          await _bloc.savePhoto(_caseItem.id, null, dstName);
          Toast.show(LangCamera.savedSuccessfully, context);
        }
      } else {
        dstName = '$fileName.jpg';
        tmpName = 'temp.jpg';
        dstNameSuffix = '${fileName}_${LangCamera.originalFileSuffix}.jpg';
        tmpPath = '$tmpRootPath/$tmpName';
        tmpCompFile = '$tmpRootPath/$dstName';
        dstPath = '$photoRootPath/$dstName';
        dstPathSuffix = '$photoRootPath/$dstNameSuffix';

        await controller.takePicture(tmpPath);

        // Save Exif&Location
        JpegExif exifInfo = new JpegExif();
        exifInfo.imageDescription = "DCP PHOTO";
        exifInfo.software = "site.conit.app.blackboard Ver1.0";
        exifInfo.dateTimeOriginal =
            DateFormat("yyyy:MM:dd HH:mm:dd").format(dateTime).toString();
        LocationData location;
        if (_caseItem.savePosition == 1) {
          location = await _waitingLocation();
        }
        if (location != null) {
          await JpegHelper().writeExif(tmpPath, exifInfo,
              location: {'lat': location.latitude, 'lng': location.longitude});
        } else {
          await JpegHelper().writeExif(tmpPath, exifInfo);
        }

        //元のファイルの保存
        if (_caseItem.saveOriginal == 1) {
          await File(tmpPath).copy(dstPathSuffix);
          await _bloc.savePhoto(_caseItem.id, null, dstNameSuffix);
        }

        //黒板スクリーン
        BlackboardPosition position =
            await getPhotoKey.currentState.captureTemp(tmpPath);
        //画像合成
        im.Image photo = await compositePhoto(tmpPath, position);
        await JpegHelper().writeXmp(photo, _blackboardItem);
        await File(tmpCompFile).writeAsBytes(im.encodeJpg(photo, quality: 70));

        // Hash
        if (_caseItem.tamperProof == 1) {
          writeHashValue(tmpCompFile, dstPath);
        } else {
          await File(tmpCompFile).copy(dstPath);
        }
        await _bloc.savePhoto(
            _caseItem.id, _blackboardItem.constructionType, dstName);

        //一時フォルダを空にします
        Directory('$tmpRootPath').listSync(recursive: true).forEach((item) {
          item.deleteSync(recursive: true);
        });
        if (_caseItem.savePosition == 1 && location == null) {
          Toast.show(LangCamera.savedSuccessfullyButLocationCouldNotBeObtained,
              context,
              duration: 2);
        } else {
          Toast.show(LangCamera.savedSuccessfully, context);
        }
      }
      if (Platform.isAndroid) {
        await _audioCache.play("mp3/shutter.mp3");
      }
      setState(() {
        this.isBtnUsed = true;
      });
    } on CameraException catch (e) {
      return null;
    }
    return filePath;
  }

  Future<im.Image> compositePhoto(
      String srcImgPath, BlackboardPosition position) async {
    im.Image srcImg = im.decodeJpg(File(srcImgPath).readAsBytesSync());
    im.Image dstImg = JpegHelper().getRealImage(srcImg);
    im.Image retImg = im.drawImage(dstImg, position.img,
        dstX: position.point.x,
        dstY: position.point.y,
        dstW: position.width,
        dstH: position.height,
        srcX: 0,
        srcY: 0,
        srcW: position.img.width,
        srcH: position.img.height,
        blend: true);
    return JpegHelper().retRotateImage(retImg);
  }
}
