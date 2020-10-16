import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/case/case_main_bloc.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/utility/request_permission.dart';
import 'package:site_blackboard_app/views/case/cases_popup_menu_widget.dart';

class CaseMainPage extends StatefulWidget {
  CaseMainPage({this.caseId, Key key}) : super(key: key);
  final int caseId;
  @override
  _CaseMainPageState createState() => _CaseMainPageState();
}

class _CaseMainPageState extends State<CaseMainPage> {
  CaseMainBloc _bloc;
  CaseItem item;
  final String rootPath = "";
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = CaseMainBloc();
    _bloc.getById(widget.caseId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.itemStream,
      builder: (BuildContext context, AsyncSnapshot<CaseItem> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        item = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              item.name,
              style: new TextStyle(fontSize: 25),
            ),
            centerTitle: false,
            leading: IconButton(
              icon: Icon(
                IconFont.icon_back,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              CasesPopupMenuWidget(),
            ],
          ),
          body: GridView.count(
            padding: const EdgeInsets.only(top: 40.0),
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            shrinkWrap: true,
            children: <Widget>[
              _camera(item), //撮影
              _photos(), //写真一覧
              _templates(item), //黒板
              _caseSetting(), //設定
              _casesPage(), //案件一覧
              _goBack(), //戻る
            ],
          ),
        );
      },
    );
  }

  ///撮影
  Widget _camera(CaseItem item) {
    return InkWell(
      onTap: () async {
        // カメラの権限をチェック
        // check camera permission
        if (await RequestPermission.request(
            Permission.camera, LangCamera.requestCameraPermission)) {
          App.navigateTo(context, Routes.camera,
              params: {'caseId': item.id.toString()});
        }
      },
      child: _itemContainerForFunc(
          [2, 1, 2, 1], LangCaseMain.shoot, "assets/image/camera.png"),
    );
  }

  ///写真一覧
  Widget _photos() {
    return InkWell(
      onTap: () async {
        await App.navigateTo(context, Routes.constructionTypes,
            params: {'caseId': widget.caseId.toString()});
      },
      child: _itemContainerForFunc(
          [1, 2, 2, 1], LangCaseMain.albumBrowser, "assets/image/img.png"),
    );
  }

  ///黒板
  Widget _templates(CaseItem item) {
    return InkWell(
      onTap: () async {
        // 「撮影」から入力した場合は「撮影」に戻り、それ以外の場合は「案件」に戻って「撮影」にジャンプします
        var gotoCamera = await App.navigateTo(context, Routes.blackboards,
            params: {'caseId': item.id.toString(), 'cameraIn': '0'});
        if (gotoCamera ?? false) {
          // カメラの権限をチェック
          // check camera permission
          if (await RequestPermission.request(
              Permission.camera, LangCamera.requestCameraPermission)) {
            App.navigateTo(context, Routes.camera,
                params: {'caseId': widget.caseId.toString()});
          }
        }
      },
      child: _itemContainerForFunc(
          [2, 1, 1, 1], LangCaseMain.blackboard, "assets/image/blackboard.png"),
    );
  }

  ///設定
  Widget _caseSetting() {
    return InkWell(
      onTap: () async {
        await App.navigateTo(context, Routes.caseSetting,
            params: {'caseId': item.id.toString()});
      },
      child: _itemContainerForFunc(
          [1, 2, 1, 1], LangCaseMain.settings, "assets/image/setting.png"),
    );
  }

  ///案件一覧
  Widget _casesPage() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: _itemContainerForFunc([2, 1, 1, 2], LangCaseMain.caseBrowser,
          "assets/image/blackboard.png"),
    );
  }

  ///戻る
  Widget _goBack() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: _itemContainerForBack([1, 2, 1, 2], "", "assets/image/site.png"),
    );
  }

  ///ファンクションキーのスタイル
  Widget _itemContainerForFunc(List<double> borders, String name, String img) {
    return new Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: borders[0],
              color: Color(0XFFCCCCCC),
            ),
            right: BorderSide(
              width: borders[1],
              color: Color(0XFFCCCCCC),
            ),
            top: BorderSide(
              width: borders[2],
              color: Color(0XFFCCCCCC),
            ),
            bottom: BorderSide(
              width: borders[3],
              color: Color(0XFFCCCCCC),
            ),
          ),
        ),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //一个图标
                    new Container(
                      padding: EdgeInsets.only(top: 0),
                      child: new Image.asset(
                        img,
                        width: 100,
                      ),
                    ),
                    //一个文本
                    new Container(
                      padding: EdgeInsets.only(top: 0),
                      child: new Text(
                        name,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 20, color: Color(0XFF333333)),
                      ),
                    ),
                  ],
                ),
              )
            ]));
  }

  ///戻るキースタイル
  Widget _itemContainerForBack(List<double> borders, String name, String img) {
    return new Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: borders[0],
              color: Color(0XFFCCCCCC),
            ),
            right: BorderSide(
              width: borders[1],
              color: Color(0XFFCCCCCC),
            ),
            top: BorderSide(
              width: borders[2],
              color: Color(0XFFCCCCCC),
            ),
            bottom: BorderSide(
              width: borders[3],
              color: Color(0XFFCCCCCC),
            ),
          ),
        ),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: new Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: new Image(
                      image: new AssetImage(img),
                      alignment: Alignment.center,
                      height: 80,
                      fit: BoxFit.contain),
                ),
              )
            ]));
  }
}
