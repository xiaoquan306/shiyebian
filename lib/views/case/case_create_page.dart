import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/case/case_create_bloc.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:toast/toast.dart';

class CaseCreatePage extends StatefulWidget {
  @override
  _CaseCreatePageState createState() => _CaseCreatePageState();
}

class _CaseCreatePageState extends State<CaseCreatePage> {
  CaseCreateBloc _bloc;
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = CaseCreateBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _pwdController = TextEditingController();

    GlobalKey _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LangCases.caseEditor,
          style: new TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(
            IconFont.icon_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Container(
            width: 100,
            height: 6,
            padding: EdgeInsets.all(12),
            child: RaisedButton(
              color: Colors.black,
              textColor: Colors.white,
              padding: EdgeInsets.all(6),
              child: Text(LangCases.create),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onPressed: () async {
                try {
                  await (await App.db).execute("BEGIN;");
                  if ((_formKey.currentState as FormState).validate()) {
                    bool sameCaseName = await _bloc.create(
                        CaseItem(map: {
                          'name': _nameController.text,
                          'constructionName': _pwdController.text,
                        }),
                        context);
                    if (sameCaseName == false) {
                      Toast.show(LangCases.sameCaseName, context);
                    }
                    Navigator.pop(context);
                  }
                  await (await App.db).execute("COMMIT;");
                } catch (e) {
                  await (await App.db).execute("ROLLBACK;");
                  throw (e);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                Form(
                    key: _formKey,
                    // autovalidate: true,
                    child: Column(children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                              height: 5.0,
                            ),
                            Text(
                              LangCases.projectTitle,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                                textBaseline: TextBaseline.alphabetic,
                                fontSize: 14,
                                letterSpacing: 0.2,
                                wordSpacing: 1,
                                height: 1.8,
                              ),
                            ),
                          ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                      ),
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: false,
                          controller: _nameController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Color(0xFF82A712)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Color(0xFF82A712)),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide()),
                          ),
                          // ユーザ名を検証
                          validator: (v) {
                            return v.trim().length > 0
                                ? null
                                : LangCases.projectTitleNotice;
                          }),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                              height: 5.0,
                            ),
                            Text(
                              LangCases.constructionSubject,
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                                textBaseline: TextBaseline.alphabetic,
                                fontSize: 14,
                                letterSpacing: 0.2,
                                wordSpacing: 1,
                                height: 1.8,
                              ),
                            ),
                          ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                      ),
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enableInteractiveSelection: false,
                          controller: _pwdController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Color(0xFF82A712)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Color(0xFF82A712)),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide()),
                          ),
                          // ユーザ名を検証
                          validator: (v) {
                            return v.trim().length > 0
                                ? null
                                : LangCases.SubjectTitleNotice;
                          }),
                    ]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
