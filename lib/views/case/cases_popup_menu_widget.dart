import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/utility/application_profile.dart';

class CasesPopupMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PopupMenuItem<_CasesPopupType>> menus = [
      // #3375 プロフィールとログアウトを一時的に隠します
      // _item(_CasesPopupType.PROFILE, IconFont.icon_member,
      //     LangGlobal.editProfile),
      _item(
          _CasesPopupType.LICENSE, IconFont.icon_personal, LangGlobal.license),
      // #3375 プロフィールとログアウトを一時的に隠します
      // _item(_CasesPopupType.LOGOUT, IconFont.icon_exitLogon, LangGlobal.logout),
    ];
    if (ApplicationProfile.isDebug) {
      menus.add(
        _item(_CasesPopupType.TEST, IconFont.icon_tips, 'Test (Only dev mode)'),
      );
    }

    return new PopupMenuButton<_CasesPopupType>(
        itemBuilder: (BuildContext context) => menus,
        onSelected: (_CasesPopupType action) {
          switch (action) {
            case _CasesPopupType.PROFILE:
              break;
            case _CasesPopupType.LICENSE:
              App.navigateTo(
                context,
                Routes.caseLicense,
              );
              break;
            case _CasesPopupType.LOGOUT:
              break;
            case _CasesPopupType.TEST:
              App.navigateTo(context, Routes.test);
              break;
          }
        });
  }

  PopupMenuItem<_CasesPopupType> _item(
      _CasesPopupType value, IconData icon, String text) {
    return PopupMenuItem<_CasesPopupType>(
      value: value,
      height: 40,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Icon(
            icon,
            size: 25,
          ),
          new Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0)),
          new Text(text),
        ],
      ),
    );
  }
}

enum _CasesPopupType { PROFILE, LICENSE, LOGOUT, TEST }
