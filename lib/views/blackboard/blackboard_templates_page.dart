import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/views/blackboard/blackboards_drawer_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template1_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template2_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template3_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template4_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template5_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template_widget.dart';
import 'package:site_blackboard_app/views/widget/navigator_back_button.dart';
import 'package:toast/toast.dart';

class BlackboardTemplatesPage extends StatelessWidget {
  BlackboardTemplatesPage({@required this.caseId, this.caseName})
      : assert(caseId != null);

  final int caseId;
  final String caseName;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LangBlackboardTemplates.layoutSelection,
            style: new TextStyle(fontSize: 25)),
        leading: NavigatorBackButton(),
      ),
      body: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GridView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                children: <Widget>[
                  TemplateWidget(
                    caseName: caseName,
                    blackboardItem: BlackboardItem(),
                    onPressed: () {
                      App.navigateTo(context, Routes.blackboardEditor, params: {
                        'isCreate': true,
                        'caseId': caseId,
                        'blackboardTemplateId': 1
                      });
                    },
                    child: Template1Widget(),
                  ),
                  TemplateWidget(
                    caseName: caseName,
                    blackboardItem: BlackboardItem(),
                    onPressed: () {
                      App.navigateTo(context, Routes.blackboardEditor, params: {
                        'isCreate': true,
                        'caseId': caseId,
                        'blackboardTemplateId': 2
                      });
                    },
                    child: Template2Widget(),
                  ),
                  TemplateWidget(
                    caseName: caseName,
                    blackboardItem: BlackboardItem(),
                    onPressed: () {
                      App.navigateTo(context, Routes.blackboardEditor, params: {
                        'isCreate': true,
                        'caseId': caseId,
                        'blackboardTemplateId': 3
                      });
                    },
                    child: Template3Widget(),
                  ),
                  TemplateWidget(
                    caseName: caseName,
                    blackboardItem: BlackboardItem(),
                    onPressed: () {
                      App.navigateTo(context, Routes.blackboardEditor, params: {
                        'isCreate': true,
                        'caseId': caseId,
                        'blackboardTemplateId': 4
                      });
                    },
                    child: Template4Widget(),
                  ),
                  TemplateWidget(
                    caseName: caseName,
                    blackboardItem: BlackboardItem(),
                    onPressed: () {
                      App.navigateTo(context, Routes.blackboardEditor, params: {
                        'isCreate': true,
                        'caseId': caseId,
                        'blackboardTemplateId': 5
                      });
                    },
                    child: Template5Widget(),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: false,
              child: _BottomButton(
                  onPressed: () => _scaffoldKey.currentState.openDrawer()),
            )
          ],
        ),
        key: _scaffoldKey,
        drawer: BlackboardsDrawerWidget(
          onPressed: (int nowCaseId) async {
            if (nowCaseId == caseId) {
              Toast.show(LangBlackboards.currentBlackboard, context);
              return;
            } else {
              bool successCopy = await App.navigateTo(
                  context, Routes.blackboardCopy, params: {
                'caseId': nowCaseId,
                'copyToCaseId': caseId,
                'fromTemplatesPage': '0'
              });
              if (successCopy == true) {
                Toast.show(LangBlackboards.copySuccessfully, context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              }
            }
          },
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  _BottomButton({@required this.onPressed, Key key}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Text(
            LangBlackboardTemplates.layoutCopy,
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 1,
              wordSpacing: 1,
            ),
          ),
          onPressed: () {
            onPressed();
          },
        ));
  }
}
