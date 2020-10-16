import 'package:flutter/material.dart';
import 'package:site_blackboard_app/config/lang_define.dart';

Future<bool> alertDialog(BuildContext context,
    {String titleText,
    Widget contentWidget,
    String contentText,
    String okButtonText}) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: titleText != null && titleText != '' ? Text(titleText) : null,
          content: contentText != null && contentText != ''
              ? Text(contentText)
              : contentWidget,
          actions: <Widget>[
            FlatButton(
              child: Text(okButtonText ?? LangGlobal.ok),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      });
}

/// if (await confirmDialog(titleText: 'Title', contentText: 'Content')) {
///    // ...
/// }
Future<bool> confirmDialog(BuildContext context,
    {String titleText,
    Widget contentWidget,
    String contentText,
    String yesButtonText,
    String noButtonText}) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: titleText != null && titleText != '' ? Text(titleText) : null,
          content: contentText != null && contentText != ''
              ? Text(contentText)
              : contentWidget,
          actions: <Widget>[
            FlatButton(
              child: Text(noButtonText ?? LangGlobal.no),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text(yesButtonText ?? LangGlobal.yes),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      });
}
