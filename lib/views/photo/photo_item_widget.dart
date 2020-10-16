import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';
import 'package:site_blackboard_app/utility/widget_tools.dart';
import 'package:site_blackboard_app/views/widget/action_sheet_widget.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';

class PhotoItemWidget extends InheritedWidget {
  PhotoItemWidget({
    this.photoPath,
    @required this.photoItem,
    @required this.onPressed,
    @required this.onUpdate,
    // @required this.onPreview,
    @required this.onMove,
    @required this.onDelete,
    @required this.onExport,
    Key key,
  })  : assert(onPressed != null),
        super(
          key: key,
          child: _PhotoItemWidget(),
        );

  final String photoPath;
  final PhotoItem photoItem;
  final VoidCallback onPressed;
  final VoidCallback onUpdate;
  final VoidCallback onMove;
  final VoidCallback onDelete;
  final VoidCallback onExport;

  @override
  bool updateShouldNotify(PhotoItemWidget old) =>
      onMove != old.onMove ||
      onPressed != old.onPressed ||
      onUpdate != old.onUpdate ||
      onDelete != old.onDelete;
}

class _PhotoItemWidget extends StatelessWidget {
  final double height = 80;
  final double edge = 5;
  @override
  Widget build(BuildContext context) {
    final photoIteWidget = inheritedWidgetOf<PhotoItemWidget>(context);
    final onPressed = photoIteWidget.onPressed;
    return Container(
      padding: EdgeInsets.all(edge),
      height: this.height,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: new Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: this.edge),
              width: 80,
              height: this.height - 2 * edge,
              child: Image.file(
                File(photoIteWidget.photoPath +
                    "/" +
                    photoIteWidget.photoItem.name),
                fit: BoxFit.cover,
              ),
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.grey[350], width: 0.5),
              ),
            ),
            Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    height: (this.height - 2 * edge) * 2 / 3,
                    child: new Text(
                      photoIteWidget.photoItem.name,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          (File(photoIteWidget.photoPath +
                                              "/" +
                                              photoIteWidget.photoItem.name)
                                          .statSync()
                                          .size /
                                      1024)
                                  .round()
                                  .toString() +
                              "KB",
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat("yyyy/MM/dd").format(fromDateTime(
                                  photoIteWidget.photoItem.createdTime)),
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[_PhotoItemActionButton()])
          ],
        ),
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.grey[500]),
      ]),
    );
  }

  DateTime fromDateTime(int dateTime) {
    DateTime createTime = DateTime.fromMillisecondsSinceEpoch(dateTime);
    return createTime.toLocal();
  }
}

enum _CasesItemActionType { UPDATE, DELETE, PREVIEW, MOVE, EXPORT }

class _PhotoItemActionButton extends StatelessWidget {
  _PhotoItemActionButton();

  @override
  Widget build(BuildContext context) {
    final photoItemWidget = inheritedWidgetOf<PhotoItemWidget>(context);
    final onUpdate = photoItemWidget.onUpdate;
    final onDelete = photoItemWidget.onDelete;
    final onPreview = photoItemWidget.onPressed;
    final onMove = photoItemWidget.onMove;
    final onExport = photoItemWidget.onExport;

    return IconButton(
      icon: Icon(
        IconFont.icon_tips,
        color: Colors.blue,
        size: 30,
      ),
      onPressed: () async {
        switch (await actionSheet<_CasesItemActionType>(context, [
          ActionSheetItem(
              type: _CasesItemActionType.UPDATE, text: LangCases.updateCase),
          ActionSheetItem(
              type: _CasesItemActionType.PREVIEW, text: LangPhotos.preview),
          ActionSheetItem(
              type: _CasesItemActionType.MOVE, text: LangPhotos.moveFolder),
          ActionSheetItem(
              type: _CasesItemActionType.EXPORT, text: LangPhotos.photoExport),
          ActionSheetItem(
              type: _CasesItemActionType.DELETE,
              text: LangPhotos.deleteImage,
              color: Colors.red),
        ])) {
          case _CasesItemActionType.UPDATE:
            onUpdate();
            break;
          case _CasesItemActionType.DELETE:
            if (true ==
                await confirmDialog(context,
                    titleText: LangPhotos.deleteImage,
                    contentText: LangPhotos.canDeleteImage)) {
              onDelete();
            }
            break;
          case _CasesItemActionType.PREVIEW:
            onPreview();
            break;
          case _CasesItemActionType.MOVE:
            onMove();
            break;
          case _CasesItemActionType.EXPORT:
            if (true ==
                await confirmDialog(context,
                    titleText: LangPhotos.photoExport,
                    contentText: LangPhotos.canExportPhoto)) {
              onExport();
            }
            break;
          default:
        }
      },
    );
  }
}
