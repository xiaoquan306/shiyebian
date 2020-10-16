import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/utility/widget_tools.dart';
import 'package:site_blackboard_app/views/widget/action_sheet_widget.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';

class CasesItemWidget extends InheritedWidget {
  CasesItemWidget({
    @required this.caseItem,
    @required this.onPressed,
    @required this.onUpdate,
    @required this.onDelete,
    Key key,
  })  : assert(caseItem != null),
        super(key: key, child: _CasesItemWidget());

  final CaseItem caseItem;
  final VoidCallback onPressed;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  @override
  bool updateShouldNotify(CasesItemWidget old) =>
      caseItem != old.caseItem ||
      onPressed != old.onPressed ||
      onUpdate != old.onUpdate ||
      onDelete != old.onDelete;
}

class _CasesItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final casesItemWidget = inheritedWidgetOf<CasesItemWidget>(context);
    final item = casesItemWidget.caseItem;
    final onPressed = casesItemWidget.onPressed;

    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.0,
                color: Color(0xFFcccccc),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0xFFcccccc),
                  blurRadius: 5.0,
                ),
              ]),
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                  flex: 7,
                  child: InkWell(
                      onTap: () {
                        onPressed();
                      },
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Image(
                                image: AssetImage('assets/image/noimg.jpg'),
                                width: 100,
                                height: 100,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 90,
                                alignment: Alignment.topLeft,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(LangCases.caseName),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            item.name,
                                            maxLines: 1,
                                            style: TextStyle(height: 1.2),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 8),
                                          child: Text(
                                              '${LangCases.constructionSubject}: '),
                                        ),
                                        Expanded(
                                          child: Text(
                                            item.constructionName,
                                            maxLines: 1,
                                            style: TextStyle(height: 1.2),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]))),
              Expanded(
                flex: 1,
                child: _CasesItemActionButton(),
              )
            ],
          ),
        ));
  }
}

enum _CasesItemActionType { UPDATE, DELETE }

class _CasesItemActionButton extends StatelessWidget {
  _CasesItemActionButton();

  @override
  Widget build(BuildContext context) {
    final casesItemWidget = inheritedWidgetOf<CasesItemWidget>(context);
    final onUpdate = casesItemWidget.onUpdate;
    final onDelete = casesItemWidget.onDelete;

    return IconButton(
      icon: Icon(
        IconFont.icon_tips,
        color: Colors.blue,
        size: 30,
      ),
      onPressed: () async {
        try {
          await (await App.db).execute("BEGIN;");
          int num = await CaseModel().getCount();
          if (num > 1) {
            switch (await actionSheet<_CasesItemActionType>(context, [
              ActionSheetItem(
                  type: _CasesItemActionType.UPDATE,
                  text: LangCases.updateCase),
              ActionSheetItem(
                  type: _CasesItemActionType.DELETE,
                  text: LangCases.deleteCase,
                  color: Colors.red)
            ])) {
              case _CasesItemActionType.UPDATE:
                onUpdate();
                break;
              case _CasesItemActionType.DELETE:
                if (true ==
                    await confirmDialog(context,
                        titleText: LangCases.deleteCase,
                        contentText: LangCases.canDeleteSelectedCase)) {
                  onDelete();
                }
                break;
              default:
            }
          } else {
            switch (await actionSheet<_CasesItemActionType>(context, [
              ActionSheetItem(
                  type: _CasesItemActionType.UPDATE,
                  text: LangCases.updateCase),
            ])) {
              case _CasesItemActionType.UPDATE:
                onUpdate();
                break;
              default:
            }
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
