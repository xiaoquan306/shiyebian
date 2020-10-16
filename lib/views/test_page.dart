import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/model/db/photo_model.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';
import 'package:site_blackboard_app/utility/request_permission.dart';
import 'package:site_blackboard_app/utility/write_hash_value.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';
import 'package:toast/toast.dart';

class TestPage extends StatefulWidget {
  TestPage({Key key}) : super(key: key);
  @override
  _TestPage createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  Location _location = Location();
  LocationData _locationResult;
  StreamSubscription<LocationData> _locationSubscription;
  String _writeHashResult;

  @override
  void dispose() {
    _stopListen();
    super.dispose();
  }

  Future<void> _listenLocation() async {
    _locationSubscription =
        _location.onLocationChanged.handleError((dynamic err) {
      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      setState(() {
        _locationResult = currentLocation;
      });
    });
  }

  Future<void> _stopListen() async {
    _locationSubscription.cancel();
  }

  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat('#,000');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test (Only dev mode)'),
        ),
        body: Column(
          children: [
            Text(formatter.format(123)),
            Text(formatter.format(1231232212313)),
            MaterialButton(
              onPressed: () {
                _requestCameraPermission();
              },
              color: Colors.red,
              child: Text('Request camera permission'),
            ),
            MaterialButton(
              onPressed: () {
                _getGeoLocation(context);
              },
              color: Colors.red,
              child: Text('Request Location'),
            ),
            Text('Position: $_locationResult'),
            MaterialButton(
              onPressed: () {
                _generateError();
              },
              color: Colors.red,
              child: Text('Error Handler'),
            ),
            MaterialButton(
              onPressed: () {
                _writeHashValue();
              },
              color: Colors.red,
              child: Text('Write hash value'),
            ),
            Text('Write hash result: $_writeHashResult'),
          ],
        ));
  }

  _generateError() async {
    throw "An Error!!!";
  }

  _getGeoLocation(BuildContext context) async {
    if (!await _location.requestService()) {
      alertDialog(context, contentText: 'Please open location service!');
      return;
    }
    if (!await RequestPermission.request(
        Permission.location, 'ポジショニングサービスが許可されていません')) {
      return;
    }

    try {
      final LocationData res = await _location.getLocation();
      // Position p = await getCurrentPosition(
      //     forceAndroidLocationManager: true,
      //     desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _locationResult = res;
      });
      _listenLocation();
    } catch (e) {
      Toast.show(e.toString(), context);
    }
  }

  _requestCameraPermission() async {
    await RequestPermission.request(Permission.camera, 'カメラ機能が認証されていません');
  }

  _writeHashValue() async {
    List<PhotoItem> photos = await PhotoModel().findAll();
    if (photos.length <= 0) {
      setState(() {
        _writeHashResult = 'No photos';
      });
      return;
    }

    setState(() async {
      String srcFilepath = [(await App.photoPath), photos[0].name].join('/');
      String destFilepath =
          [(await App.supportDirectory).path, 'dest.jpg'].join('/');
      _writeHashResult = writeHashValue(srcFilepath, destFilepath).toString();
    });
  }
}
