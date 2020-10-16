import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:site_blackboard_app/bloc/photo/photo_move_bloc.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';
import 'package:toast/toast.dart';

class PhotoMovePage extends StatefulWidget {
  PhotoMovePage({
    @required this.photoId,
    Key key,
  }) : super(key: key);

  final int photoId;

  @override
  PhotoMovePageState createState() => PhotoMovePageState();
}

class PhotoMovePageState extends State<PhotoMovePage> {
  PhotoMoveBloc _fileMoveBloc;
  List<ForderInfo> dirs = new List<ForderInfo>();
  List<CaseItem> caseItemList = new List<CaseItem>();
  List<ConstructionTypeItem> constructionTypeItemList =
      new List<ConstructionTypeItem>();
  PhotoItem _photoItem = new PhotoItem();
  @override
  void initState() {
    _fileMoveBloc = PhotoMoveBloc();
    _fileMoveBloc.fetchCasesItem();
    _fileMoveBloc.fetchConstructionTypeItem();
    _fileMoveBloc.getPhotoItemById(widget.photoId);
    super.initState();
  }

  @override
  void dispose() {
    dirs = new List<ForderInfo>();
    _fileMoveBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamBuilder(
      stream: _fileMoveBloc.caseItemListStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<CaseItem>> caseItemBlocSnapshot) {
        if (caseItemBlocSnapshot.data != null) {
          caseItemList = caseItemBlocSnapshot.data.toList();
        }
        if (!caseItemBlocSnapshot.hasData) {
          return Container();
        }
        return StreamBuilder(
          stream: _fileMoveBloc.constructionTypeItemListStream,
          builder: (BuildContext context,
              AsyncSnapshot<List<ConstructionTypeItem>> constructionSnapshot) {
            if (constructionSnapshot.data != null) {
              constructionTypeItemList = constructionSnapshot.data.toList();
              getDirs();
            }
            if (!constructionSnapshot.hasData) {
              return Container();
            }
            return StreamBuilder(
              stream: _fileMoveBloc.photoItemStream,
              builder: (BuildContext context,
                  AsyncSnapshot<PhotoItem> photoItemSnapshot) {
                if (!photoItemSnapshot.hasData) {
                  return Container();
                }
                if (photoItemSnapshot != null) {
                  _photoItem.id = photoItemSnapshot.data.id;
                  _photoItem.name = photoItemSnapshot.data.name;
                  _photoItem.updatedTime = photoItemSnapshot.data.updatedTime;
                  _photoItem.constructionTypeId =
                      photoItemSnapshot.data.constructionTypeId;
                  _photoItem.createdTime = photoItemSnapshot.data.createdTime;
                  _photoItem.deletedTime = photoItemSnapshot.data.deletedTime;
                  _photoItem.id = photoItemSnapshot.data.id;
                }
                return Scaffold(
                  appBar: AppBar(
                    title: new Text(
                      photoItemSnapshot.data.name,
                      style: new TextStyle(fontSize: 25),
                    ),
                    leading: new IconButton(
                      icon: Icon(IconFont.icon_back, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  body: folderListViewer(),
                );
              },
            );
          },
        );
      },
    );
  }

  getDirs() {
    dirs.clear();
    int cnt = 0;
    int subCnt = 0;
    double dep = 0;

    // int index = 0;
    caseItemList.forEach((caseItem) {
      dep = 0;
      subCnt = 0;
      dirs.add(new ForderInfo(caseItem.name, dep, true, 0, 0));
      constructionTypeItemList.forEach((constructionTypeItem) {
        if (caseItem.id == constructionTypeItem.caseId) {
          dirs.add(new ForderInfo(constructionTypeItem.name, dep + 1, true,
              subCnt, constructionTypeItem.id));
          subCnt++;
          cnt++;
        }
      });
    });
  }

  Widget folderListViewer() {
    return ListView.builder(
      itemCount: dirs.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            if (dirs[index].dep == 0) {
              Toast.show(
                LangPhotos.unableMove,
                context,
                duration: 2,
              );
            } else {
              await deletePrompt(dirs[index]);
              _fileMoveBloc.getPhotoItemById(widget.photoId);
            }
            Navigator.pop(context);
          },
          child: Visibility(
            visible: dirs[index].expanded,
            child: Container(
              child: folderRowItem(dirs[index]),
              padding: EdgeInsets.only(left: dirs[index].dep * 35),
              decoration:
                  BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey[500]),
              ]),
            ),
          ),
        );
      },
    );
  }

  deletePrompt(ForderInfo item) async {
    if (await confirmDialog(context,
        contentText: lang(LangPhotos.moveFilesNotice,
            {'txt1': _photoItem.name, 'txt2': item.fileName}),
        yesButtonText: LangGlobal.yes,
        noButtonText: LangGlobal.no)) {
      if (caseItemList.contains(item.fileName)) {
      } else {
        _photoItem.constructionTypeId = item.constructionTypeId;
        await _fileMoveBloc.updatePhotoItem(_photoItem);
      }
    }
  }

  Widget folderRowItem(ForderInfo subDir) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.all(10.0),
              child: Icon(
                IconFont.icon_folder,
                color: Colors.orange,
                size: 35,
              ),
            ),
            Expanded(
              child: Text(subDir.fileName),
            ),
          ],
        ),
      ],
    );
  }
}

class ForderInfo {
  final String fileName;
  final double dep;
  bool expanded;
  int childsCnt;
  int constructionTypeId;

  ForderInfo(this.fileName, this.dep, this.expanded, this.childsCnt,
      this.constructionTypeId);
}
