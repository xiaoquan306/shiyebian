import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';
import 'package:site_blackboard_app/utility/widget_tools.dart';
import 'package:site_blackboard_app/views/widget/action_sheet_widget.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';

class ConstructionTypesItemWidget extends InheritedWidget {
  ConstructionTypesItemWidget({
    @required this.constructionTypesItem,
    @required this.onPressed,
    @required this.onUpdate,
    @required this.onDelete,
    @required this.onExport,
    Key key,
  })  : assert(constructionTypesItem != null),
        super(key: key, child: _ConstructionTypesItemWidget());

  final ConstructionTypeItem constructionTypesItem;
  final VoidCallback onPressed;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  final VoidCallback onExport;

  @override
  bool updateShouldNotify(ConstructionTypesItemWidget old) =>
      constructionTypesItem != old.constructionTypesItem ||
      onPressed != old.onPressed ||
      onUpdate != old.onUpdate ||
      onDelete != old.onDelete;
}

class _ConstructionTypesItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final constructionTypesItemWidget =
        inheritedWidgetOf<ConstructionTypesItemWidget>(context);
    final item = constructionTypesItemWidget.constructionTypesItem;
    final onPressed = constructionTypesItemWidget.onPressed;
    final double edge = 5;
    final double height = 80;
    return new Container(
      padding: EdgeInsets.all(edge),
      height: height,
      child: InkWell(
          onTap: () async {
            if (item.photoCount != null) {
              onPressed();
            }
          },
          child: new Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: edge),
                width: 80,
                height: height - 2 * edge,
                child: Icon(
                  IconFont.icon_folder,
                  color: Colors.orange,
                  size: height - 6 * edge,
                ),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.grey[350], width: 0.5),
                ),
              ),
              Expanded(
                flex: 3,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      height: (height - 2 * edge) * 2 / 3,
                      child: new Text(
                        item.name,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                    new Container(
                      child: Row(
                        children: <Widget>[
                          // GetItemSize(this.items[index]),
                          Text(
                            item.photoCount != null
                                ? item.photoCount.toString() + " item"
                                : "0" + " item",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                DateFormat("yyyy/MM/dd")
                                    .format(fromDateTime(item.createdTime)),
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
              Expanded(
                flex: 1,
                child: _ConstructionTypesItemActionButton(),
              )
            ],
          )),
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

enum _ConstructionTypesItemActionType { DELETE, EXPORT }

class _ConstructionTypesItemActionButton extends StatelessWidget {
  _ConstructionTypesItemActionButton();

  @override
  Widget build(BuildContext context) {
    final constructionTypesItemWidget =
        inheritedWidgetOf<ConstructionTypesItemWidget>(context);
    final onDelete = constructionTypesItemWidget.onDelete;
    final onExport = constructionTypesItemWidget.onExport;

    return IconButton(
      icon: Icon(
        IconFont.icon_tips,
        color: Colors.blue,
        size: 30,
      ),
      onPressed: () async {
        try {
          await (await App.db).execute("BEGIN;");
          switch (await actionSheet<_ConstructionTypesItemActionType>(context, [
            ActionSheetItem(
                type: _ConstructionTypesItemActionType.DELETE,
                text: LangConstructionTypes.deleteFolder,
                color: Colors.black),
            ActionSheetItem(
                type: _ConstructionTypesItemActionType.EXPORT,
                text: LangConstructionTypes.constructionTypeExport,
                color: Colors.black),
          ])) {
            case _ConstructionTypesItemActionType.DELETE:
              if (true ==
                  await confirmDialog(context,
                      titleText: LangConstructionTypes.deleteFolder,
                      contentText:
                          LangConstructionTypes.canIDeleteTheSelectedFolder)) {
                onDelete();
              }
              break;
            case _ConstructionTypesItemActionType.EXPORT:
              if (true ==
                  await confirmDialog(context,
                      titleText: LangConstructionTypes.constructionTypeExport,
                      contentText: LangPhotos.canExportPhoto)) {
                onExport();
              }
              break;
            default:
          }
          await (await App.db).execute("COMMIT;");
        } catch (e) {
          await (await App.db).execute("ROLLBACK;");
          throw (e);
        }
      },
    );
  }
}
