import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/photo/photos_bloc.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';
import 'package:site_blackboard_app/utility/request_permission.dart';
import 'package:site_blackboard_app/views/photo/photo_item_widget.dart';

class PhotosPage extends StatefulWidget {
  PhotosPage(
      {this.constructionTypeId,
      this.constructionTypeName,
      this.caseName,
      Key key})
      : super(key: key);
  final int constructionTypeId;
  final String constructionTypeName;
  final String caseName;

  @override
  PhotosPageState createState() => PhotosPageState();
}

class PhotosPageState extends State<PhotosPage> {
  PhotosBloc _photosBloc;
  final double height = 80;
  final double edge = 5;
  String curFoldName = "";
  String sortBtnName = LangPhotos.sortByName;
  bool isSortDown = true;
  bool sortName = true;
  bool sortByName = false;
  bool sortByDate = true;
  bool nameController = true;
  IconData sortBtnIcon = Icons.arrow_downward;
  String photoPreviewListJson;
  String photoPath;
  List<PhotoItem> photoPreviewList = new List<PhotoItem>();
  static final TextEditingController fileNameTextController =
      TextEditingController();

  @override
  void initState() {
    _photosBloc = PhotosBloc();
    _photosBloc.photoOrder(
        nameController, widget.constructionTypeId, isSortDown);
    Future.delayed(
        Duration.zero,
        () => setState(() {
              getPhotoUrl();
            }));
    super.initState();
  }

  @override
  void dispose() {
    _photosBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.constructionTypeName,
            style: new TextStyle(fontSize: 25),
          ),
          leading: new IconButton(
            icon: Icon(IconFont.icon_back, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: StreamBuilder(
            stream: _photosBloc.fetchAllStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<PhotoItem>> photoBlocSnapshot) {
              if (!photoBlocSnapshot.hasData) {
                return Container();
              }
              photoPreviewList = photoBlocSnapshot.data.toList();
              photoPreviewListJson = json.encode(photoPreviewList);
              List<Widget> list = List();
              photoBlocSnapshot.data.toList().forEach((item) {
                list.add(PhotoItemWidget(
                  photoPath: photoPath,
                  photoItem: item,
                  onPressed: () async {
                    await App.navigateTo(context, Routes.photoPreview, params: {
                      'photoPreviewList': photoPreviewListJson,
                      'path': photoPath,
                      'size': File(photoPath + "/" + item.name)
                          .statSync()
                          .size
                          .toString(),
                      'date': item.updatedTime.toString(),
                      'photoId': item.id.toString()
                    });
                    photoPreviewList.clear();
                    _photosBloc.photoOrder(
                        nameController, widget.constructionTypeId, isSortDown);
                  },
                  onUpdate: () {
                    showDialog<Null>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        fileNameTextController.text =
                            item.name.replaceAll('.jpg', '');
                        return new AlertDialog(
                          title: new Text(LangPhotos.enterTheImageName),
                          content: new SingleChildScrollView(
                              child: Column(
                            children: [
                              new TextField(
                                enableInteractiveSelection: true,
                                controller: fileNameTextController,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  RaisedButton(
                                    onPressed: () async {
                                      var name =
                                          fileNameTextController.text + '.jpg';
                                      await _photosBloc.update(
                                          item, name, context);
                                      _photosBloc
                                          .fetchAll(widget.constructionTypeId);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(LangGlobal.ok),
                                  ),
                                  Spacer(),
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(LangGlobal.back),
                                  ),
                                ],
                              ),
                            ],
                          )),
                        );
                      },
                    ).then((val) {
                      photoPreviewList.clear();
                      _photosBloc.photoOrder(nameController,
                          widget.constructionTypeId, isSortDown);
                    });
                  },
                  onMove: () async {
                    await App.navigateTo(context, Routes.photoMove,
                        params: {'photoId': item.id.toString()});
                    _photosBloc.photoOrder(
                        nameController, widget.constructionTypeId, isSortDown);
                  },
                  onDelete: () async {
                    photoPreviewList.clear();
                    await _photosBloc.delete(item);
                    _photosBloc.photoOrder(
                        nameController, widget.constructionTypeId, isSortDown);
                  },
                  onExport: () async {
                    if (await RequestPermission.request(Permission.storage,
                        LangCamera.requestCameraPermission)) {
                      photoExport(item.name);
                    }
                  },
                ));
              });
              return Column(
                children: [
                  new Container(
                    width: double.infinity,
                    height: 50,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 130,
                          height: 35,
                          child: RaisedButton(
                            onPressed: () async {
                              constructionTypeOrder(
                                  context, widget.constructionTypeId);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(this.sortBtnName),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  this.sortBtnIcon,
                                  size: 15,
                                ),
                              ],
                            ),
                            textColor: Colors.black,
                            color: Colors.grey[350],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(children: list),
                  ),
                ],
              );
            }));
  }

  getPhotoUrl() async {
    photoPath = await App.photoPath;
  }

  photoExport(String photoName) async {
    String exportPath = await App.exportPath;
    //判断案件文件夹是否存在，不存在就创建
    if (!Directory(exportPath + '/' + widget.caseName).existsSync()) {
      Directory(exportPath + '/' + widget.caseName).createSync(recursive: true);
    }
    //判断工种文件夹是否存在，不存在就创建
    if (!Directory(exportPath +
            '/' +
            widget.caseName +
            '/' +
            widget.constructionTypeName)
        .existsSync()) {
      Directory(exportPath +
              '/' +
              widget.caseName +
              '/' +
              widget.constructionTypeName)
          .createSync();
    }

    //判断照片是否存在如果不存在就复制，如果存在就先删除在复制
    if (!File(exportPath +
            '/' +
            widget.caseName +
            '/' +
            widget.constructionTypeName +
            '/' +
            photoName)
        .existsSync()) {
      File(photoPath + '/' + photoName).copySync(exportPath +
          '/' +
          widget.caseName +
          '/' +
          widget.constructionTypeName +
          '/' +
          photoName);
    } else {
      File(photoPath + '/' + photoName).copySync(exportPath +
          '/' +
          widget.caseName +
          '/' +
          widget.constructionTypeName +
          '/' +
          photoName);
    }
  }

  constructionTypeOrder(BuildContext context, constructionTypeId) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(LangConstructionTypes.sorting),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Offstage(
                        offstage: sortByName,
                        child: Icon(Icons.check),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        LangConstructionTypes.sortByName,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  setState(() {
                    nameController = true;
                    if (!sortByName) {
                      if (isSortDown) {
                        isSortDown = false;
                        this.sortBtnIcon = Icons.arrow_upward;
                      } else {
                        isSortDown = true;
                        this.sortBtnIcon = Icons.arrow_downward;
                      }
                    } else {
                      sortByName = !sortByName;
                      sortByDate = !sortByDate;
                      this.sortBtnName = LangConstructionTypes.sortByName;
                      isSortDown = true;
                      this.sortBtnIcon = Icons.arrow_downward;
                    }
                  });
                  photoPreviewList.clear();
                  photoPreviewList = await _photosBloc.photoOrder(
                      nameController, widget.constructionTypeId, isSortDown);
                  Navigator.of(context).pop();
                },
              ),
              CupertinoActionSheetAction(
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Offstage(
                        offstage: sortByDate,
                        child: Icon(Icons.check),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        LangConstructionTypes.sortByUpdated,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  setState(() {
                    nameController = false;
                    if (!sortByDate) {
                      if (isSortDown) {
                        isSortDown = false;
                        this.sortBtnIcon = Icons.arrow_upward;
                      } else {
                        isSortDown = true;
                        this.sortBtnIcon = Icons.arrow_downward;
                      }
                    } else {
                      sortByName = !sortByName;
                      sortByDate = !sortByDate;
                      this.sortBtnName = LangConstructionTypes.sortByUpdated;
                      isSortDown = true;
                      this.sortBtnIcon = Icons.arrow_downward;
                    }
                  });
                  photoPreviewList.clear();
                  photoPreviewList = await _photosBloc.photoOrder(
                      sortByDate, widget.constructionTypeId, isSortDown);
                  Navigator.of(context).pop();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                LangGlobal.cancel,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              isDestructiveAction: true,
            ),
          );
        });
  }
}
