import 'package:flutter/material.dart';
import 'package:site_blackboard_app/config/icon_font.dart';

class NavigatorBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        IconFont.icon_back,
        size: 30,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
