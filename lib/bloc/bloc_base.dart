import 'package:flutter/material.dart';
import 'package:site_blackboard_app/utility/application_profile.dart';
import 'package:site_blackboard_app/utility/log.dart';

/// Bloc抽象クラス
abstract class BlocBase {
  BuildContext superContext;

  void dispose();

  void callLog(String callName) {
    if (!ApplicationProfile.isDebug) {
      return;
    }

    Log.info('Calling bloc: $callName');
  }
}
