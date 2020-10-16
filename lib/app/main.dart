import 'dart:async';

import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/app/app_component.dart';
import 'package:site_blackboard_app/app/error_handler.dart';

Future<Null> main() async {
  // グローバルエラー処理
  ErrorHandler(_runner);
}

/// 応用スターター
Future<Null> _runner() async {
  await App.start();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppComponent());
}
