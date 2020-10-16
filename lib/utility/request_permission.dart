import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/lang_define.dart';

/// 許可ツールのリクエスト
abstract class RequestPermission {
  /// リクエスト
  static Future<bool> request(Permission permission, String alert) async {
    PermissionStatus status = await permission.request();
    if (status.isGranted) {
      return true;
    }

    await _confirm(permission, status, alert);
    return false;
  }

  /// 一括リクエスト
  static Future<Map<Permission, bool>> batchRequest(
      BuildContext context, Map<Permission, String> permissions) async {
    Map<Permission, bool> results = {};

    for (var entry in permissions.entries) {
      PermissionStatus status = await entry.key.request();
      if (status.isGranted) {
        results[entry.key] = true;
      } else {
        await _confirm(entry.key, status, entry.value);
        results[entry.key] = false;
      }
    }

    return results;
  }

  /// [システム設定]でオンにしてください
  static _confirm(
      Permission permission, PermissionStatus status, String alert) async {
    if (!(Platform.isIOS && status.isDenied ||
        Platform.isAndroid && status.isPermanentlyDenied)) {
      return;
    }

    bool goAppSettings = await showDialog(
        context: App.navigatorKey.currentState.overlay.context,
        builder: (context) {
          return AlertDialog(
            content: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: alert,
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: '\n\n[',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                  text: LangRequestPermission.systemSettings,
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pop(true);
                    }),
              TextSpan(
                  text: ']' + LangRequestPermission.pleaseOpenIt,
                  style: TextStyle(color: Colors.black))
            ])),
            actions: <Widget>[
              new FlatButton(
                child: new Text(LangGlobal.back),
                textColor: Colors.black26,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              new FlatButton(
                child: new Text(LangRequestPermission.systemSettings),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (goAppSettings) {
      openAppSettings();
    }
  }
}
