import 'dart:io';

import 'package:flutter/foundation.dart';

class ApplicationProfile {
  static bool get isRelease => kReleaseMode;

  static bool get isDebug => kDebugMode;

  static bool get isProfile => kProfileMode;

  static bool get isWeb => kIsWeb;

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIos => Platform.isIOS;
}
