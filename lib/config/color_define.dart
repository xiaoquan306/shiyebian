import 'package:flutter/material.dart';

class Colours {
//色の設定
  static const Color appMain = Color(0xFFB2CB39);
  static const Color gray1 = Color(0xFF222222);
  static const Color gray2 = Color(0xFF464A54);
  static const Color gray3 = Color(0xFF808080);
  static const Color gray4 = Color(0xFFAAB2BD);
  static const Color gray5 = Color(0xFFE6E9ED);
  static const Color gray6 = Color(0xFFF5F7FA);
  static const Color accent = Color(0xFFFF3455);
  static const Color separator = Color(0xFFC7C7C7);
  static const Color background = Color(0xFFEEEEEE);
  static const Color navigation = Color(0xFFF9F9F9);
  static const Color navBarDark = Color(0xff007260);
  static const Color linkBlue = Color(0xFF006abc);
  static const Color templateGreen = Color(0xff218F32);

  static MaterialColor getAppMainColor() {
    Color color = Color(0xFFB2CB39);
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - g)) * ds).round(),
          1);
    });
    return MaterialColor(color.value, swatch);
  }
}
