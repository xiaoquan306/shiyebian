import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/edit_exif.dart';

void main() {
  const MethodChannel channel = MethodChannel('edit_exif');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterExif.platformVersion, '42');
  });
}
