import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/photo/construction_types_bloc.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/model/db/photo_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';
import 'package:site_blackboard_app/utility/request_permission.dart';
import 'package:site_blackboard_app/views/photo/construction_types_item_widget.dart';

class ConstructionTypesPage extends StatefulWidget {
  ConstructionTypesPage({this.caseId, Key key}) : super(key: key);
  final int caseId;

  @override
  _ConstructionTypesPageState createState() => _ConstructionTypesPageState();
}

class _ConstructionTypesPageState extends State<ConstructionTypesPage> {
  ConstructionTypeBloc _bloc;
  String sortBtnName = LangConstructionTypes.sortByName;
  bool isSortDown;
  bool sortByName;
  bool sortByDate;
  bool nameController;
  IconData sortBtnIcon = Icons.arrow_downward;
  PhotoModel photoModel;
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    isSortDown = true;
    sortByName = false;
    sortByDate = true;
    nameController = true;
    String a = "12.6591";
    List<String> b = a.split(".");
    String f = ((num.parse(a) - num.parse(b[0])) * 60).toString().split(".")[0];
    String m = ((((num.parse(a) - num.parse(b[0])) * 60) - num.parse(f)) * 60)
        .toString();
    _bloc = ConstructionTypeBloc();
    _bloc.getCaseById(widget.caseId);
    // _bloc.fetchAll(widget.caseId);
    _bloc.constructionTypeOrder(nameController, widget.caseId, isSortDown);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamBuilder(
      stream: _bloc.getCaseByIdStream,
      builder:
          (BuildContext context, AsyncSnapshot<CaseItem> caseItemSnapshot) {
        if (!caseItemSnapshot.hasData) {
          return Container();
        }
        return StreamBuilder(
          stream: _bloc.fetchAllStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ConstructionTypeItem>> constructionSnapshot) {
            if (!constructionSnapshot.hasData) {
              return Container();
            }
            List<Widget> list = List();
            constructionSnapshot.data.forEach((item) {
              list.add(ConstructionTypesItemWidget(
                constructionTypesItem: item,
                onPressed: () async {
                  await App.navigateTo(context, Routes.photos, params: {
                    'constructionTypeId': item.id.toString(),
                    'constructionTypeName': item.name,
                    'caseName': caseItemSnapshot.data.name,
                  });
                  //_bloc.fetchAll(widget.caseId);

                  _bloc.constructionTypeOrder(
                      nameController, widget.caseId, isSortDown);
                },
                onUpdate: () async {
                  await App.navigateTo(context, Routes.caseUpdate,
                      params: {'caseId': item.id.toString()});
                  //_bloc.fetchAll(widget.caseId);
                  _bloc.constructionTypeOrder(
                      nameController, widget.caseId, isSortDown);
                },
                onExport: () async {
                    if (await RequestPermission.request(Permission.storage,
                        LangCamera.requestCameraPermission)) {
                      photoModel = new PhotoModel();
                      List<PhotoItem> photoList =
                          await photoModel.findByConstructionTypeId(item.id);
                      constructionTypeExport(
                          caseItemSnapshot.data.name, item.name, photoList);
                    }
                },
                onDelete: () async {
                  await _bloc.delete(item);
                  //_bloc.fetchAll(widget.caseId);
                  _bloc.constructionTypeOrder(
                      nameController, widget.caseId, isSortDown);
                },
              ));
            });
            return Scaffold(
              appBar: AppBar(
                title: new Text(
                  caseItemSnapshot.data.name,
                  style: new TextStyle(fontSize: 25),
                ),
                leading: new IconButton(
                  icon: Icon(IconFont.icon_back, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Column(
                children: <Widget>[
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
                              constructionTypeOrder(context, widget.caseId);
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
              ),
            );
          },
        );
      },
    );
  }

  constructionTypeExport(String caseName, String constructionTypeName,
      List<PhotoItem> photoList) async {
    String exportPath = await App.exportPath;
    String photoPath = await App.photoPath;
    //案件フォルダが存在するかどうかを判断し、存在しないなら作成します
    if (!Directory(exportPath + '/' + caseName).existsSync()) {
      Directory(exportPath + '/' + caseName).createSync(recursive: true);
    }
    //工種フォルダが存在するかどうかを判断し、存在しないなら作成します
    if (!Directory(exportPath + '/' + caseName + '/' + constructionTypeName)
        .existsSync()) {
      Directory(exportPath + '/' + caseName + '/' + constructionTypeName)
          .createSync();
    }
    photoList.forEach((element) {
      //写真が存在するかどうかを判断します。存在しないならコピーします。
      if (!File(exportPath +
              '/' +
              caseName +
              '/' +
              constructionTypeName +
              '/' +
              element.name)
          .existsSync()) {
        File(photoPath + '/' + element.name).copySync(exportPath +
            '/' +
            caseName +
            '/' +
            constructionTypeName +
            '/' +
            element.name);
      } else {
        File(photoPath + '/' + element.name).copySync(exportPath +
            '/' +
            caseName +
            '/' +
            constructionTypeName +
            '/' +
            element.name);
      }
    });
  }

  ///ディレクトリの並べ替え,デフォルトでは名前で降順に並べ替え
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
                onPressed: () {
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
                  _bloc.constructionTypeOrder(
                      nameController, constructionTypeId, isSortDown);
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
                onPressed: () {
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
                  _bloc.constructionTypeOrder(
                      nameController, widget.caseId, isSortDown);
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
