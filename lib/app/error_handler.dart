import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/utility/log.dart';

typedef Runner = Future<Null> Function();

/// グローバルエラー処理
class ErrorHandler {
  ErrorHandler(Runner runner) {
    // ErrorWidget.builder = (FlutterErrorDetails details) {
    //   Log.severe('---------- Capture by ErrorWidget.builder ----------');
    //   String strError = details.exception.toString();
    //   String strStackTrace = details.stack.toString();
    //   Log.severe(strError);
    //   Log.severe(strStackTrace);
    //   _reportHandler(strError, strStackTrace);
    //   return _promptPage(strError, strStackTrace);
    // };

    // 異常リダイレクト
    FlutterError.onError = (FlutterErrorDetails details) async {
      Log.severe('---------- Capture by FlutterError.onError ----------');
      Zone.current.handleUncaughtError(details.exception, details.stack);
    };
    Isolate.current.addErrorListener(new RawReceivePort((dynamic pair) async {
      Log.severe(
          '---------- Capture by Isolate.current.addErrorListener ----------');
      var isolateError = pair as List<dynamic>;
      _process(isolateError.first.toString(), isolateError.last.toString());
    }).sendPort);

    // runner
    runZoned<Future<Null>>(runner,
        onError: (dynamic error, StackTrace stackTrace) async {
      Log.severe('---------- Capture by runZonedGuarded.onError ----------');
      _process(error, stackTrace);
    });
  }

  _process(dynamic error, dynamic stackTrace) async {
    String strError = error.toString();
    String strStackTrace = stackTrace.toString();

    Log.severe(strError);
    Log.severe(strStackTrace);

    try {
      bool report = await _promptHandler(strError, strStackTrace);
      if (report) {
        _reportHandler(strError, strStackTrace);
      }
    } catch (e) {
      Log.severe('PromptHandler or ReportHandler exception: $e');
    }
  }

  Future<bool> _promptHandler(String error, String stackTrace) async {
    return await showDialog(
        context: App.navigatorKey.currentState.overlay.context,
        builder: (context) {
          return AlertDialog(
            title: Text(LangGlobal.anErrorOccurred),
            content: Text(error),
            actions: <Widget>[
              new FlatButton(
                child: new Text(LangGlobal.ok),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
  }

  Widget _promptPage(String error, String stackTrace) {
    return Center(
      child: Column(
        children: [
          Text(LangGlobal.anErrorOccurred),
          Text(error),
        ],
      ),
    );
  }

  _reportHandler(String error, String stackTrace) async {}
}
