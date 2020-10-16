import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:site_blackboard_app/config/lang_define.dart';

/// 画面の下部からスライドするモーダルポップアップを表示します。
///
/// e.g.
/// enum myActionType = {UPDATE, DELETE};
/// ...
/// MaterialButton(onPressed: () async {
///   switch (await actionSheet<int>(context, [
///     ActionSheetItem<myActionType>(
///         type: myActionType.UPDATE,
///         text: LangCases.updateCase),
///     ActionSheetItem<myActionType>(
///         type: myActionType.DELETE,
///         text: LangCases.deleteCase,
///         color: Colors.red)
///   ])) {
///     case myActionType.UPDATE:
///       // Handle this case...
///       break;
///     case myActionType.DELETE:
///       // Handle this case...
///       break;
///   }
/// });
Future<T> actionSheet<T>(BuildContext context, List<ActionSheetItem<T>> actions,
    {bool disabledCancelButton = false, String cancelButtonText}) async {
  assert(context != null);
  assert(actions != null);
  List<Widget> actionsWidget = [];
  actions.forEach((item) {
    actionsWidget.add(CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context, item.type);
        },
        child: Text(item.text,
            style:
                TextStyle(color: item.color ?? Colors.black, fontSize: 20))));
  });

  return await showCupertinoModalPopup<T>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: actionsWidget,
          cancelButton: false == disabledCancelButton
              ? CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(cancelButtonText ?? LangGlobal.cancel,
                      style: TextStyle(color: Colors.black, fontSize: 20)))
              : null,
        );
      });
}

class ActionSheetItem<T> {
  final T type;
  final String text;
  final Color color;

  ActionSheetItem({@required this.type, @required this.text, this.color});
}
