import 'dart:async';

import 'package:flutter/services.dart';

class FlutterExif {
  String path;
  FlutterExif(this.path);
  static const MethodChannel _channel = const MethodChannel('edit_exif');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future setExif(Map exif) async {
    //android https://developer.android.google.cn/reference/android/support/media/ExifInterface?hl=zh-cn
    //ios https://developer.apple.com/documentation/imageio/cgimageproperties/exif_dictionary_keys
    await _channel.invokeMethod(
        'setExif', <String, dynamic>{'path': this.path, 'exif': exif});
  }
}
