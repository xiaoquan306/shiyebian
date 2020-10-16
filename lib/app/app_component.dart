import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/color_define.dart';
import 'package:site_blackboard_app/utility/application_profile.dart';

/// APPコンポーネント
class AppComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      title: DotEnv().env['APP_NAME'],
      navigatorKey: App.navigatorKey,
      onGenerateRoute: App.router.generator,
      theme: ThemeData(
        platform: ApplicationProfile.isIos ? TargetPlatform.iOS : null,
        primarySwatch: Colours.getAppMainColor(),
        fontFamily: 'HiraginoSans',
        backgroundColor: Colours.background,
      ),
    );
  }
}
