import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:site_blackboard_app/bloc/blackboard/blackboard_editor_bloc.dart';
import 'package:site_blackboard_app/config/color_define.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/utility/global_event.dart';
import 'package:site_blackboard_app/views/blackboard/template1_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template2_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template3_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template4_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template5_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template_widget.dart';
import 'package:site_blackboard_app/views/widget/navigator_back_button.dart';

class BlackboardEditorPage extends StatefulWidget {
  BlackboardEditorPage(
      {@required this.isCreate,
      @required this.caseId,
      this.blackboardId,
      this.blackboardTemplateId})
      : assert(isCreate != null),
        assert(caseId != null);

  final bool isCreate;
  final int caseId;
  final int blackboardId;
  final int blackboardTemplateId;

  @override
  _BlackboardEditorPageState createState() => _BlackboardEditorPageState();
}

class _BlackboardEditorPageState extends State<BlackboardEditorPage> {
  BlackboardEditorBloc _bloc;
  AsyncSnapshot<BlackboardItem> _blackboardItemSnapshot;
  final Map<String, int> projectItems = {
    BlackboardColumn.largeClassification: 0,
    BlackboardColumn.photoClassification: 1,
    BlackboardColumn.constructionType: 2,
    BlackboardColumn.middleClassification: 3,
    BlackboardColumn.smallClassification: 4,
    BlackboardColumn.title: 5,
    BlackboardColumn.classificationRemarks1: 6,
    BlackboardColumn.classificationRemarks2: 7,
    BlackboardColumn.classificationRemarks3: 8,
    BlackboardColumn.classificationRemarks4: 9,
    BlackboardColumn.classificationRemarks5: 10,
    BlackboardColumn.shootingSpot: 11,
    BlackboardColumn.isRepresentative: 12,
    BlackboardColumn.isFrequencyOfSubmission: 13,
    BlackboardColumn.contructor: 14,
    BlackboardColumn.contractorRemarks: 15
  };
  final Map<String, int> measureItems = {
    BlackboardColumn.classification: 0,
    BlackboardColumn.name: 1,
    BlackboardColumn.mark: 2,
    BlackboardColumn.designedValue: 3,
    BlackboardColumn.measuredValue: 4,
    BlackboardColumn.unitName: 5,
    BlackboardColumn.remarks1: 6,
    BlackboardColumn.remarks2: 7,
    BlackboardColumn.remarks3: 8,
    BlackboardColumn.remarks4: 9,
    BlackboardColumn.remarks5: 10
  };
  List<_InputItem> _projectInputItems = [
    _InputItem(
      column: BlackboardColumn.largeClassification,
      text: LangBlackboardEditor.largeClassification,
      type: _InputType.TEXT,
      isHidden: false,
      isListAndCanEditor: true,
    ),
    _InputItem(
        column: BlackboardColumn.photoClassification,
        text: LangBlackboardEditor.photoClassification,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: true),
    _InputItem(
        column: BlackboardColumn.constructionType,
        text: LangBlackboardEditor.constructionType,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.middleClassification,
        text: LangBlackboardEditor.middleClassification,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.smallClassification,
        text: LangBlackboardEditor.smallClassification,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.title,
        text: LangBlackboardEditor.title,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.classificationRemarks1,
        text: LangBlackboardEditor.classificationRemarks1,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.classificationRemarks2,
        text: LangBlackboardEditor.classificationRemarks2,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.classificationRemarks3,
        text: LangBlackboardEditor.classificationRemarks3,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.classificationRemarks4,
        text: LangBlackboardEditor.classificationRemarks4,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.classificationRemarks5,
        text: LangBlackboardEditor.classificationRemarks5,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.shootingSpot,
        text: LangBlackboardEditor.shootingLocation,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.isRepresentative,
        text: LangBlackboardEditor.isRepresentative,
        type: _InputType.CHECKBOX,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.isFrequencyOfSubmission,
        text: LangBlackboardEditor.isFrequencyOfSubmission,
        type: _InputType.CHECKBOX,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.contructor,
        text: LangBlackboardEditor.contractor,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.contractorRemarks,
        text: LangBlackboardEditor.contractorRemarks,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
  ];
  List<_InputItem> _measureInputItems = [
    _InputItem(
        column: BlackboardColumn.classification,
        text: LangBlackboardEditor.classification,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: true),
    _InputItem(
        column: BlackboardColumn.name,
        text: LangBlackboardEditor.name,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.mark,
        text: LangBlackboardEditor.mark,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.designedValue,
        text: LangBlackboardEditor.designedValue,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.measuredValue,
        text: LangBlackboardEditor.measuredValue,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.unitName,
        text: LangBlackboardEditor.unitName,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.remarks1,
        text: LangBlackboardEditor.remarks1,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.remarks2,
        text: LangBlackboardEditor.remarks2,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.remarks3,
        text: LangBlackboardEditor.remarks3,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.remarks4,
        text: LangBlackboardEditor.remarks4,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false),
    _InputItem(
        column: BlackboardColumn.remarks5,
        text: LangBlackboardEditor.remarks5,
        type: _InputType.TEXT,
        isHidden: false,
        isListAndCanEditor: false)
  ];

  @override
  void initState() {
    _bloc = BlackboardEditorBloc();
    _bloc.getCaseById(widget.caseId);
    _bloc.getBlackboardById(
        widget.blackboardId, widget.caseId, widget.blackboardTemplateId);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabItems = [
      LangBlackboardEditor.constructionContent,
      LangBlackboardEditor.measurementItems
    ];

    return StreamBuilder(
        stream: _bloc.getCaseByIdStream,
        builder:
            (BuildContext context, AsyncSnapshot<CaseItem> caseItemSnapshot) {
          if (!caseItemSnapshot.hasData) {
            return Container();
          }
          return StreamBuilder(
              stream: _bloc.getBlackboardByIdStream,
              builder: (BuildContext context,
                  AsyncSnapshot<BlackboardItem> blackboardItemSnapshot) {
                if (!blackboardItemSnapshot.hasData) {
                  return Container();
                }
                _blackboardItemSnapshot = blackboardItemSnapshot;
                if (_blackboardItemSnapshot.data.blackboardId == 5) {
                  _projectInputItems
                      .elementAt(projectItems[BlackboardColumn.shootingSpot])
                      .text = LangBlackboardTemplates.shootingPlace;
                  _projectInputItems
                      .elementAt(projectItems[BlackboardColumn.title])
                      .text = LangBlackboardTemplates.shootingContent;
                }
                if (_blackboardItemSnapshot.data.classificationRemarks1 ==
                        null ||
                    _blackboardItemSnapshot
                            .data.classificationRemarks1.length ==
                        0) {
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks2])
                      .isHidden = true;
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks3])
                      .isHidden = true;
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks4])
                      .isHidden = true;
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks5])
                      .isHidden = true;
                }
                if (_blackboardItemSnapshot.data.classificationRemarks2 ==
                        null ||
                    _blackboardItemSnapshot
                            .data.classificationRemarks2.length ==
                        0) {
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks3])
                      .isHidden = true;
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks4])
                      .isHidden = true;
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks5])
                      .isHidden = true;
                }

                if (_blackboardItemSnapshot.data.classificationRemarks3 ==
                        null ||
                    _blackboardItemSnapshot
                            .data.classificationRemarks3.length ==
                        0) {
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks4])
                      .isHidden = true;
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks5])
                      .isHidden = true;
                }
                if (_blackboardItemSnapshot.data.classificationRemarks4 ==
                        null ||
                    _blackboardItemSnapshot
                            .data.classificationRemarks4.length ==
                        0) {
                  _projectInputItems
                      .elementAt(
                          projectItems[BlackboardColumn.classificationRemarks5])
                      .isHidden = true;
                }

                if (_blackboardItemSnapshot.data.remarks1 == null ||
                    _blackboardItemSnapshot.data.remarks1.length == 0) {
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks2])
                      .isHidden = true;
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks3])
                      .isHidden = true;
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks4])
                      .isHidden = true;
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks5])
                      .isHidden = true;
                }
                if (_blackboardItemSnapshot.data.remarks2 == null ||
                    _blackboardItemSnapshot.data.remarks2.length == 0) {
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks3])
                      .isHidden = true;
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks4])
                      .isHidden = true;
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks5])
                      .isHidden = true;
                }

                if (_blackboardItemSnapshot.data.remarks3 == null ||
                    _blackboardItemSnapshot.data.remarks3.length == 0) {
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks4])
                      .isHidden = true;
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks5])
                      .isHidden = true;
                }
                if (_blackboardItemSnapshot.data.remarks4 == null ||
                    _blackboardItemSnapshot.data.remarks4.length == 0) {
                  _measureInputItems
                      .elementAt(measureItems[BlackboardColumn.remarks5])
                      .isHidden = true;
                }

                return DefaultTabController(
                    length: tabItems.length,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(caseItemSnapshot.data.name),
                        leading: NavigatorBackButton(),
                        actions: [
                          _appBarActionBuilder(
                            widget.isCreate,
                            onPressed: () {
                              _save();
                            },
                          )
                        ],
                      ),
                      body: ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 220,
                                child: _tplBuilder(
                                    caseName: caseItemSnapshot.data.name,
                                    blackboardItem:
                                        _blackboardItemSnapshot.data),
                              ),
                              Container(
                                height: 50,
                                child: _tabBarBuilder(tabItems),
                                decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: Colors.grey))),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height +
                                            300),
                                child: TabBarView(
                                  children: [
                                    ListView(
                                      shrinkWrap: true,
                                      physics:
                                          new NeverScrollableScrollPhysics(),
                                      children: _formFieldsBuilder(
                                          inputItems: _projectInputItems,
                                          blackboardItem:
                                              blackboardItemSnapshot.data,
                                          onChange:
                                              (int itemIndex, dynamic value) {
                                            if (itemIndex == 6) {
                                              if (value != null ||
                                                  value.length != 0) {
                                                setState(() {
                                                  _projectInputItems
                                                      .elementAt(projectItems[
                                                          BlackboardColumn
                                                              .classificationRemarks2])
                                                      .isHidden = false;
                                                });
                                              }
                                            }
                                            if (itemIndex == 7) {
                                              if (value != null ||
                                                  value.length != 0) {
                                                setState(() {
                                                  _projectInputItems
                                                      .elementAt(projectItems[
                                                          BlackboardColumn
                                                              .classificationRemarks3])
                                                      .isHidden = false;
                                                });
                                              }
                                            }
                                            if (itemIndex == 8) {
                                              if (value != null ||
                                                  value.length != 0) {
                                                setState(() {
                                                  _projectInputItems
                                                      .elementAt(projectItems[
                                                          BlackboardColumn
                                                              .classificationRemarks4])
                                                      .isHidden = false;
                                                });
                                              }
                                            }
                                            if (itemIndex == 9) {
                                              if (value != null ||
                                                  value.length != 0) {
                                                setState(() {
                                                  _projectInputItems
                                                      .elementAt(projectItems[
                                                          BlackboardColumn
                                                              .classificationRemarks5])
                                                      .isHidden = false;
                                                });
                                              }
                                            }

                                            _changeValue(itemIndex, value);
                                          }),
                                    ),
                                    ListView(
                                      shrinkWrap: true,
                                      physics:
                                          new NeverScrollableScrollPhysics(),
                                      children: _formFieldsBuilder(
                                          inputItems: _measureInputItems,
                                          blackboardItem:
                                              blackboardItemSnapshot.data,
                                          onChange:
                                              (int itemIndex, dynamic value) {
                                            if (itemIndex == 6) {
                                              if (value != null ||
                                                  value.length != 0) {
                                                setState(() {
                                                  _measureInputItems
                                                      .elementAt(measureItems[
                                                          BlackboardColumn
                                                              .remarks2])
                                                      .isHidden = false;
                                                });
                                              }
                                            }
                                            if (itemIndex == 7) {
                                              if (value != null ||
                                                  value.length != 0) {
                                                setState(() {
                                                  _measureInputItems
                                                      .elementAt(measureItems[
                                                          BlackboardColumn
                                                              .remarks3])
                                                      .isHidden = false;
                                                });
                                              }
                                            }
                                            if (itemIndex == 8) {
                                              if (value != null ||
                                                  value.length != 0) {
                                                setState(() {
                                                  _measureInputItems
                                                      .elementAt(measureItems[
                                                          BlackboardColumn
                                                              .remarks4])
                                                      .isHidden = false;
                                                });
                                              }
                                            }
                                            if (itemIndex == 9) {
                                              if (value != null ||
                                                  value.length != 0) {
                                                setState(() {
                                                  _measureInputItems
                                                      .elementAt(measureItems[
                                                          BlackboardColumn
                                                              .remarks5])
                                                      .isHidden = false;
                                                });
                                              }
                                            }

                                            _changeMeasureValue(
                                                itemIndex, value);
                                          }),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ));
              });
        });
  }

  void _save() async {
    // データの保存または変更
    if (widget.isCreate) {
      await _bloc.create(_blackboardItemSnapshot.data);
      Navigator.of(context).pop();
    } else {
      await _bloc.update(_blackboardItemSnapshot.data);
    }
    Navigator.of(context).pop();
  }

  void _changeValue(int itemIndex, dynamic value) {
    // _projectInputItems[itemIndex].value = value;
    final String column = _projectInputItems[itemIndex].column;
    final _InputType type = _projectInputItems[itemIndex].type;

    Map<String, dynamic> newData = _blackboardItemSnapshot.data.toMap();
    if (newData.containsKey(column)) {
      if (type == _InputType.TEXT) {
        newData[column] = value.toString();
      } else if (type == _InputType.CHECKBOX) {
        newData[column] = value ? 1 : 0;
      }
    }
    _blackboardItemSnapshot.data.fromMap(newData);

    globalEventBus.fire(BlackboardChangeEvent(_blackboardItemSnapshot.data));
  }

  void _changeMeasureValue(int itemIndex, dynamic value) {
    final String column = _measureInputItems[itemIndex].column;

    Map<String, dynamic> newData = _blackboardItemSnapshot.data.toMap();
    if (newData.containsKey(column)) {
      newData[column] = value.toString();
    }
    _blackboardItemSnapshot.data.fromMap(newData);

    globalEventBus.fire(BlackboardChangeEvent(_blackboardItemSnapshot.data));
  }
}

// AppBarのActions
Container _appBarActionBuilder(bool isCreate, {VoidCallback onPressed}) {
  return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      child: RaisedButton(
        color: Colors.black,
        hoverColor: Colors.black54,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        child: Text(isCreate ? LangBlackboards.create : LangBlackboards.create),
        onPressed: () {
          onPressed();
        },
      ));
}

// 黒板のプレビュー
TemplateWidget _tplBuilder(
    {@required String caseName, @required BlackboardItem blackboardItem}) {
  switch (blackboardItem.blackboardId) {
    case 1:
      return TemplateWidget(
        caseName: caseName,
        blackboardItem: blackboardItem,
        useEvent: true,
        child: Template1Widget(),
      );
    case 2:
      return TemplateWidget(
        caseName: caseName,
        blackboardItem: blackboardItem,
        useEvent: true,
        child: Template2Widget(),
      );
    case 3:
      return TemplateWidget(
        caseName: caseName,
        blackboardItem: blackboardItem,
        useEvent: true,
        child: Template3Widget(),
      );
    case 4:
      return TemplateWidget(
        caseName: caseName,
        blackboardItem: blackboardItem,
        useEvent: true,
        child: Template4Widget(),
      );
    case 5:
      return TemplateWidget(
        caseName: caseName,
        blackboardItem: blackboardItem,
        useEvent: true,
        child: Template5Widget(),
      );
    default:
      return null;
  }
}

// DefaultTabControllerのTabBar
TabBar _tabBarBuilder(List<String> tabItems) {
  return TabBar(
    indicator: BoxDecoration(
      color: Colors.white,
      border: Border(
          left: BorderSide(width: 1, color: Colors.grey),
          right: BorderSide(width: 1, color: Colors.grey)),
    ),
    tabs: tabItems.map((item) {
      return Tab(text: item);
    }).toList(),
    labelColor: Colors.black,
    indicatorColor: Colors.black45,
  );
}

typedef FieldOnChangeCallback(int itemIndex, dynamic value);

// フォームのフィールド
List<Widget> _formFieldsBuilder(
    {@required List<_InputItem> inputItems,
    @required BlackboardItem blackboardItem,
//    @required Key key,
    @required FieldOnChangeCallback onChange}) {
  final map = blackboardItem.toMap();
  return inputItems.asMap().keys.map((i) {
    _InputItem inputItem = inputItems[i];

    // 種類に応じて初期値を設定します。
    dynamic value;
    if (inputItem.type == _InputType.TEXT) {
      value = map.containsKey(inputItem.column) ? map[inputItem.column] : '';
    } else if (inputItem.type == _InputType.CHECKBOX) {
      value = map.containsKey(inputItem.column)
          ? map[inputItem.column] == 1
          : false;
    }
    if (inputItem.column == 'classification') {
      if (value == '0') {
        value = LangBlackboardEditor.nameItem0;
      } else if (value == '1') {
        value = LangBlackboardEditor.nameItem1;
      } else if (value == '2') {
        value = LangBlackboardEditor.nameItem2;
      } else if (value == '3') {
        value = LangBlackboardEditor.nameItem3;
      } else if (value == '9') {
        value = LangBlackboardEditor.nameItem9;
      }
    }

    // 入力項目を描画
    return Visibility(
        child: Container(
            padding: EdgeInsets.only(
              top: 6,
              left: 10,
              right: 10,
            ),
            child: Row(children: [
              Container(
                  width: 140,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    inputItem.text,
                    style: TextStyle(fontSize: 16),
                  )),
              Expanded(
                  child: Container(
                      child: inputItem.type == _InputType.TEXT
                          ? _TextFieldWidget(
                              isListAndCanEditor: inputItem.isListAndCanEditor,
                              filedTextName: inputItem.text,
                              value: value,
                              onChanged: (String value) {
                                onChange(i, value.toString());
                              })
                          : _CheckboxWidget(
                              value: value,
                              onChanged: (bool value) {
                                onChange(i, !!value);
                              },
                            ))),
            ])),
        visible: inputItem.isHidden == true ? false : true);
  }).toList();
}

/// テキスト入力ボックス
// ignore: must_be_immutable
class _TextFieldWidget extends StatefulWidget {
  _TextFieldWidget(
      {this.value,
      this.onChanged,
      this.isListAndCanEditor,
      this.filedTextName,
      Key key})
      : super(key: key);

  final String value;
  final ValueChanged<String> onChanged;
  final bool isListAndCanEditor;
  final String filedTextName;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<_TextFieldWidget>
    with AutomaticKeepAliveClientMixin {
  String _value;
  TextEditingController _contentController;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _value = widget.value;
    _contentController =
        TextEditingController.fromValue(TextEditingValue(text: _value ?? ''));
    super.initState();
  }

  Widget _photoShowModalBottomSheet(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification1,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification1);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification2,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification2);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification3,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification3);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification4,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification4);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification5,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification5);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification6,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification6);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification7,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification7);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification8,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification8);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.photoClassification9,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.photoClassification9);
          },
        ),
      ],
    );
  }

  Widget _classificationShowModalBottomSheet(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.nameItem0,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.nameItem0);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.nameItem1,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.nameItem1);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.nameItem2,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.nameItem2);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.nameItem3,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.nameItem3);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.nameItem9,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.nameItem9);
          },
        ),
      ],
    );
  }

  Widget _bigClassificationShowModalBottomSheet(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          isDestructiveAction: false,
          child: Text(LangBlackboardEditor.largeClassification1,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.largeClassification1);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.largeClassification2,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.largeClassification2);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.largeClassification3,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.largeClassification3);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.largeClassification4,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.largeClassification4);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.largeClassification5,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.largeClassification5);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.largeClassification6,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.largeClassification6);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LangBlackboardEditor.largeClassification7,
              style: TextStyle(color: Colors.black, fontSize: 14)),
          onPressed: () {
            valueChange(LangBlackboardEditor.largeClassification7);
          },
        ),
      ],
    );
  }

  valueChange(String cloumnName) {
    setState(() {
      _contentController.text = cloumnName;
      widget.onChanged(cloumnName);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TextField(
        enableInteractiveSelection: false,
        onTap: () {
          if (widget.filedTextName ==
              LangBlackboardEditor.largeClassification) {
            FocusScope.of(context).requestFocus(new FocusNode());
          }
          if (widget.filedTextName == LangBlackboardEditor.classification) {
            FocusScope.of(context).requestFocus(new FocusNode());
          }
        },
        onChanged: (String value) {
          widget.onChanged(value);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colours.background)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colours.linkBlue)),
          suffixIcon: widget.isListAndCanEditor
              ? IconButton(
                  icon: Icon(Icons.storage),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          if (widget.filedTextName ==
                              LangBlackboardEditor.largeClassification) {
                            return _bigClassificationShowModalBottomSheet(
                                context);
                          } else if (widget.filedTextName ==
                              LangBlackboardEditor.photoClassification) {
                            return _photoShowModalBottomSheet(context);
                          } else if (widget.filedTextName ==
                              LangBlackboardEditor.classification) {
                            return _classificationShowModalBottomSheet(context);
                          } else {
                            return null;
                          }
                        });
                  },
                )
              : null,
        ),
        controller: _contentController);
  }
}

/// チェックボックス
class _CheckboxWidget extends StatefulWidget {
  _CheckboxWidget({this.value, this.onChanged, Key key}) : super(key: key);

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<_CheckboxWidget> {
  bool _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _value,
      activeColor: Colors.red,
      onChanged: (bool value) {
        widget.onChanged(value);
        setState(() {
          _value = value;
        });
      },
    );
  }
}

/// 入力項目情報
class _InputItem {
  final String column;
  String text;
  final _InputType type;
  bool isHidden;
  bool isListAndCanEditor;
  // TextEditingController ctrl;
  // dynamic value;

  // static List<TextEditingController> _ctrls = [];
  // static List<TextEditingController> get ctrls => _ctrls;

  _InputItem({
    @required this.column,
    @required this.text,
    @required this.type,
    @required this.isHidden,
    @required this.isListAndCanEditor,
  }) {
    // if (type == _InputType.CHECKBOX) {
    //   value = false;
    // }
  }
}

// 入力項目カのテゴリ
enum _InputType { TEXT, CHECKBOX }
