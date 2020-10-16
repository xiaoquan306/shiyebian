import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/case/case_setting_bloc.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:toast/toast.dart';

class CaseSettingPage extends StatefulWidget {
  CaseSettingPage({this.caseId, Key key}) : super(key: key);
  final int caseId;

  @override
  _CaseSettingPageState createState() => _CaseSettingPageState();
}

class _CaseSettingPageState extends State<CaseSettingPage> {
  CaseSettingBloc _bloc;
  CaseItem item;
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = CaseSettingBloc();
    _bloc.getById(widget.caseId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _bloc.getCaseByIdStream,
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
                  icon: Icon(IconFont.icon_back, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Column(
                children: [
                  _addLocationInformation(item),
                  _useBlackBoard(item),
                  _saveOriginalPhoto(item),
                  _tamperProof(item)
                ],
              ));
        });
  }

  ///位置情報を付ける
  Widget _addLocationInformation(CaseItem item) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(LangCaseSetting.addLocationInformation),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              width: 80,
              child: Switch(
                  activeColor: Colors.pinkAccent,
                  value: item.savePosition == 1 ? true : false,
                  onChanged: (value) async {
                    try {
                      await (await App.db).execute("BEGIN;");
                      item.savePosition = item.savePosition == 1 ? 0 : 1;
                      await _bloc.update(item);
                      await (await App.db).execute("COMMIT;");
                    } catch (e) {
                      await (await App.db).execute("ROLLBACK;");
                      throw (e);
                    }
                  })),
        ],
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.grey[500]),
      ]),
    );
  }

  ///黒板表示
  Widget _useBlackBoard(CaseItem item) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(LangCaseSetting.useBlackBoard),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              width: 80,
              child: Switch(
                  activeColor: Colors.pinkAccent,
                  value: item.useBlackboard == 1 ? true : false,
                  onChanged: (value) async {
                    try {
                      await (await App.db).execute("BEGIN;");
                      if (item.blackboardDefault != null) {
                        item.useBlackboard = item.useBlackboard == 1 ? 0 : 1;
                        if (item.useBlackboard != 1) {
                          item.saveOriginal = 0;
                        }
                      } else {
                        Toast.show(LangCaseSetting.blackboardHasNotBeenSetYet,
                            context);
                      }
                      await _bloc.update(item);
                      await (await App.db).execute("COMMIT;");
                    } catch (e) {
                      await (await App.db).execute("ROLLBACK;");
                      throw (e);
                    }
                  })),
        ],
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.grey[500]),
      ]),
    );
  }

  ///黒板なし写真を同時保存する
  Widget _saveOriginalPhoto(CaseItem item) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(LangCaseSetting.saveOriginalPhoto),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              width: 80,
              child: Switch(
                  activeColor: Colors.pinkAccent,
                  value: item.saveOriginal == 1 ? true : false,
                  onChanged: (value) async {
                    try {
                      await (await App.db).execute("BEGIN;");
                      if (item.useBlackboard != 1) {
                        item.saveOriginal = 0;
                      } else {
                        item.saveOriginal = item.saveOriginal == 1 ? 0 : 1;
                      }
                      await _bloc.update(item);
                      await (await App.db).execute("COMMIT;");
                    } catch (e) {
                      await (await App.db).execute("ROLLBACK;");
                      throw (e);
                    }
                  })),
        ],
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.grey[500]),
      ]),
    );
  }

  ///改ざん防止
  Widget _tamperProof(CaseItem item) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Text(LangCaseSetting.tamperProof),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              width: 80,
              child: Switch(
                  activeColor: Colors.pinkAccent,
                  value: item.tamperProof == 1 ? true : false,
                  onChanged: (value) async {
                    try {
                      await (await App.db).execute("BEGIN;");
                      item.tamperProof = item.tamperProof == 1 ? 0 : 1;
                      await _bloc.update(item);
                      await (await App.db).execute("COMMIT;");
                    } catch (e) {
                      await (await App.db).execute("ROLLBACK;");
                      throw (e);
                    }
                  })),
        ],
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.grey[500]),
      ]),
    );
  }
}
