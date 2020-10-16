import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:site_blackboard_app/bloc/photo/photo_preview_bloc.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';
import 'package:site_blackboard_app/utility/jpeg_helper.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';

class PhotoPreviewPage extends StatefulWidget {
  PhotoPreviewPage(
      {this.path,
      this.size,
      this.date,
      this.photoId,
      this.photoPreviewList,
      Key key});
  final String path;

  final int size;
  final String date;
  final int photoId;
  final String photoPreviewList;
  @override
  _PhotoPreviewPageState createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  int width;
  int height;
  String pixels;
  String photoName;
  PhotoPreviewBloc _photoPreviewBloc;
  PhotoViewController controller;
  //現在選択されている写真の位置
  int currentPhotoInPhotoPreviewList;
  List photoPreviewList;
  PageController _controller;
//  double scaleCopy;
//  PhotoViewScaleStateController scaleStateController;
  @override
  void initState() {
    photoPreviewList = json.decode(widget.photoPreviewList);
    for (int i = 0; i < photoPreviewList.length; i++) {
      if (photoPreviewList[i]["id"] == widget.photoId) {
        currentPhotoInPhotoPreviewList = i;
      }
    }
    _photoPreviewBloc = PhotoPreviewBloc();
    _photoPreviewBloc.findPhotoById(widget.photoId);
    getImagePix(widget.path +
        "/" +
        photoPreviewList[currentPhotoInPhotoPreviewList]["name"]);
    _controller =
        new PageController(initialPage: currentPhotoInPhotoPreviewList);
    photoName = photoPreviewList[currentPhotoInPhotoPreviewList]["name"];
//    scaleStateController = PhotoViewScaleStateController();
    super.initState();
//    controller = PhotoViewController()..outputStateStream.listen(listener);
  }

//  void listener(PhotoViewControllerValue value) {
//    setState(() {
//      scaleCopy = value.scale;
//    });
//  }
//------------------------------------------ダブルクリックしてズームアウトする機能は実装されていません。最初にコメントアウトしてから、実装します。
  @override
  void dispose() {
//    scaleStateController.dispose();
    _photoPreviewBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamBuilder(
        stream: _photoPreviewBloc.photoItemStream,
        builder: (BuildContext context, AsyncSnapshot<PhotoItem> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var item;
          if (snapshot.data != null) {
            item = snapshot.data;
          }
          return Scaffold(
            appBar: AppBar(
              title: AutoSizeText(
                photoName,
                minFontSize: 18,
                maxLines: 1,
              ),
              leading: IconButton(
                icon: Icon(
                  IconFont.icon_back,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    IconFont.icon_delete,
                    size: 28,
                  ),
                  onPressed: () async {
                    // bool delete = await showDeleteConfirmDialog1(item);
                    if (await confirmDialog(context,
                            titleText: LangPhotoPreview.shingles,
                            contentText: LangPhotoPreview.confirmDelete,
                            yesButtonText: LangGlobal.yes,
                            noButtonText: LangGlobal.no) ??
                        false) {
                      await _photoPreviewBloc.delete(item);
                      _photoPreviewBloc.findPhotoById(widget.photoId);
                      Navigator.pop(context);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    IconFont.icon_tips,
                    size: 35,
                  ),
                  onPressed: () async {
                    tips();
                  },
                ),
              ],
            ),
            body: PhotoViewGallery.builder(
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions.customChild(
                  child: Image.file(
                    File(widget.path + "/" + photoPreviewList[index]["name"]),
                    fit: BoxFit.contain,
                  ),

//                  scaleStateController: scaleStateController,
                  initialScale: PhotoViewComputedScale.contained * 1,
                  minScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.covered * 3,
//                  gestureDetectorBehavior:,
                );
              },
              itemCount: photoPreviewList.length,
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              pageController: _controller,
//------------------------------------------ダブルクリックしてズームアウトする機能は実装されていません。最初にコメントアウトしてから、実装します。
//              scaleStateChangedCallback: (PhotoViewScaleState state) {
//                if (state.isScaleStateZooming) {
//                  scaleStateController.scaleState =
//                      PhotoViewScaleState.originalSize;
//                }
//              },

              onPageChanged: (index) {
                setState(() {
                  photoName = photoPreviewList[index]["name"];
                });
              },
            ),
          );
        });
  }

  Future<void> tips() async {
    NumberFormat formatter = NumberFormat('#,000');
    String byte = formatter.format(widget.size);
    var timestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(widget.date));
    String time = DateFormat("yyyy/MM/dd HH:mm:dd").format(timestamp);
    String size = (widget.size / 1024).round().toString();
    Map obj = await JpegHelper().readXmpAndExif('${widget.path}/$photoName');
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text(LangPhotoPreview.detailedInformation),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: const Text(LangPhotoPreview.fileInformation),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    '${LangPhotoPreview.path} : ${widget.path}/$photoName'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    '${LangPhotoPreview.size} : ${size}KB  ($byte${LangPhotoPreview.byte})'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child:
                    Text('${LangPhotoPreview.changeDate} : ${time.toString()}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    '${LangPhotoPreview.numberOfPixels} : $pixels  (${width.toString()}x${height.toString()})'),
              ),
              obj.keys.contains(ExifItem.TAG_GPS_LATITUDE_REF)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child:
                              const Text(LangPhotoPreview.locationInformation),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              '${LangPhotoPreview.latitude} : ${obj[ExifItem.TAG_GPS_LATITUDE_REF]}${obj[ExifItem.TAG_GPS_LATITUDE]}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              '${LangPhotoPreview.longitude} : ${obj[ExifItem.TAG_GPS_LONGITUDE_REF]}${obj[ExifItem.TAG_GPS_LONGITUDE]}'),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              obj.keys.contains(XmpItem.LargeClassification) ||
                      obj.keys.contains(XmpItem.PhotoClassification)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: const Text(
                              LangPhotoPreview.blackboardInformation),
                        ),
                        obj.keys.contains(XmpItem.LargeClassification)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                    '${LangPhotoPreview.majorClassification} : ${obj[XmpItem.LargeClassification]}'),
                              )
                            : Container(),
                        obj.keys.contains(XmpItem.PhotoClassification)
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                    '${LangPhotoPreview.photoClassification} : ${obj[XmpItem.PhotoClassification]}'),
                              )
                            : Container(),
                      ],
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RaisedButton(
                      color: Colors.black,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Text(LangPhotoPreview.close),
                      onPressed: () => Navigator.of(context).pop(), //ダイアログを閉じる
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  getImagePix(String path) {
    Image image = Image.file(File.fromUri((Uri.parse(path))));
    image.image
        .resolve(new ImageConfiguration())
        .addListener(new ImageStreamListener((ImageInfo info, bool) {
      width = info.image.width;
      height = info.image.height;
      pixels = ((width * height / 10000).round()).toString() +
          LangPhotoPreview.millionPixels;
    }));
  }
}
