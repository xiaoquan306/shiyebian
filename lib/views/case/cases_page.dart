import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/case/cases_bloc.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/views/case/cases_item_widget.dart';
import 'package:site_blackboard_app/views/case/cases_popup_menu_widget.dart';

class CasesPage extends StatefulWidget {
  CasesPage({Key key}) : super(key: key);

  @override
  _CasesPageState createState() => _CasesPageState();
}

class _CasesPageState extends State<CasesPage> {
  CasesBloc _bloc;
  GlobalKey _wigetKey = GlobalKey();
  int _activatedCaseId = 0;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = CasesBloc();
    _bloc.fetchAll();
    _gotoActivatedCaseMainPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text(LangCases.caseBrowser, style: new TextStyle(fontSize: 25)),
          centerTitle: true,
          actions: <Widget>[
            CasesPopupMenuWidget(),
          ],
        ),
        body: StreamBuilder(
            stream: _bloc.fetchAllStream,
            builder:
                (BuildContext context, AsyncSnapshot<List<CaseItem>> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              List<Widget> list = List();
              snapshot.data.forEach((item) {
                if (item.activated == 1) {
                  _activatedCaseId = item.id;
                }

                list.add(CasesItemWidget(
                  caseItem: item,
                  onPressed: () async {
                    await App.navigateTo(context, Routes.caseMain,
                        params: {'caseId': item.id.toString()});
                    _bloc.fetchAll();
                  },
                  onUpdate: () async {
                    await App.navigateTo(context, Routes.caseUpdate,
                        params: {'caseId': item.id.toString()});
                    _bloc.fetchAll();
                  },
                  onDelete: () async {
                    await _bloc.delete(item);
                    _bloc.fetchAll();
                  },
                ));
              });

              return Column(
                key: _wigetKey,
                children: [
                  Expanded(
                    child: ListView(children: list),
                  ),
                  Offstage(
                      offstage: false,
                      child: MaterialButton(
                        child: Text(
                          LangCases.createCase,
                          style: TextStyle(
                            fontSize: 18,
                            letterSpacing: 5,
                            wordSpacing: 15,
                          ),
                        ),
                        minWidth: double.infinity,
                        height: 50,
                        textColor: Color(0xFF050E00),
                        color: Color(0xFFB2CB39),
                        onPressed: () async {
                          await App.navigateTo(context, Routes.caseCreate);
                          _bloc.fetchAll();
                        },
                      ))
                ],
              );
            }));
  }

  _gotoActivatedCaseMainPage() async {
    while (_wigetKey.currentWidget == null) {
      await Future.delayed(const Duration(milliseconds: 100), () {});
    }

    if (_activatedCaseId > 0) {
      await App.navigateTo(context, Routes.caseMain,
          params: {'caseId': _activatedCaseId});
      _bloc.fetchAll();
    }
  }
}
