import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/blackboard/blackboards_bloc.dart';
import 'package:site_blackboard_app/config/color_define.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/views/blackboard/blackboards_drawer_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template1_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template2_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template3_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template4_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template5_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template_widget.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';
import 'package:toast/toast.dart';

class BlackboardsPage extends StatefulWidget {
  BlackboardsPage({@required this.caseId, this.fromCamera = false})
      : assert(caseId != null);
  final bool fromCamera;
  final int caseId;

  @override
  _BlackboardsPageState createState() => _BlackboardsPageState();
}

class _BlackboardsPageState extends State<BlackboardsPage> {
  BlackboardsBloc _bloc;
  BlackboardItem _selectBlackboardItem;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = BlackboardsBloc();
    _bloc.getCaseById(widget.caseId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            LangBlackboards.blackboardList,
            style: new TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            icon: Icon(
              IconFont.icon_back,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          actions: <Widget>[
            StreamBuilder(
                stream: _bloc.getCaseByIdStream,
                builder: (BuildContext context,
                    AsyncSnapshot<CaseItem> caseItemSnapshot) {
                  if (!caseItemSnapshot.hasData) {
                    return Container();
                  }
                  return Container(
                      width: 100,
                      padding: EdgeInsets.all(12),
                      child: RaisedButton(
                        color: Colors.black,
                        hoverColor: Colors.black54,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Text(LangBlackboards.addNew),
                        onPressed: () async {
                          await App.navigateTo(
                              context, Routes.blackboardTemplates,
                              params: {
                                'caseId': caseItemSnapshot.data.id.toString(),
                                'caseName':
                                    caseItemSnapshot.data.name.toString()
                              });
                          _bloc.getCaseById(widget.caseId);
                        },
                      ));
                }),
          ],
        ),
        body: Scaffold(
            body: StreamBuilder(
                stream: _bloc.getCaseByIdStream,
                builder: (BuildContext context,
                    AsyncSnapshot<CaseItem> caseItemSnapshot) {
                  if (!caseItemSnapshot.hasData) {
                    return Container();
                  }

                  _bloc.fetchByCaseId(caseItemSnapshot.data.id);

                  return StreamBuilder(
                      stream: _bloc.fetchByCaseIdStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BlackboardItem>>
                              blackboardsSnapshot) {
                        if (!blackboardsSnapshot.hasData) {
                          return Container();
                        }

                        return Column(children: <Widget>[
                          InkWell(
                              onTap: () {
                                Scaffold.of(context).openDrawer();
                              },
                              child: Ink(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                color: Colours.background,
                                child: Text(
                                    '${LangBlackboards.caseName}: ${caseItemSnapshot.data.name}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                              )),
                          Expanded(
                              child: _BlackboardsWidget(
                            key: UniqueKey(),
                            caseItem: caseItemSnapshot.data,
                            blackboards: blackboardsSnapshot.data,
                            onSelected: (BlackboardItem item) async {
                              if (widget.caseId == caseItemSnapshot.data.id) {
                                _selectBlackboardItem = item;
                              }
                            },
                            onPhotography: (BlackboardItem item) async {
                              await _bloc.changeDefaultBlackboard(
                                  caseItem: caseItemSnapshot.data,
                                  blackboardItem: item);
                              Navigator.of(context).pop(true);
                            },
                            onUpdate: (BlackboardItem item) async {
                              await App.navigateTo(
                                  context, Routes.blackboardEditor, params: {
                                'isCreate': false,
                                'caseId': widget.caseId,
                                'blackboardId': item.id
                              });
                              _bloc.getCaseById(caseItemSnapshot.data.id);
                            },
                            onDelete: (BlackboardItem item) async {
                              await _bloc.delete(item);
                              _bloc.getCaseById(widget.caseId);
                            },
                          )),
                          Offstage(
                              offstage: false,
                              child: _BottomButton(
                                caseItem: caseItemSnapshot.data,
                                onPressed: () async {
                                  // 黒板がないので、操作禁止です
                                  if (blackboardsSnapshot.data.length <= 0) {
                                    Toast.show(
                                        LangBlackboards.makeNewBlackboard,
                                        context);
                                    return;
                                  }

                                  // この案件で新しい黒板を選択したら、デフォルトの黒板を更新します
                                  if (widget.caseId ==
                                      caseItemSnapshot.data.id) {
                                    if (_selectBlackboardItem == null) {
                                      Toast.show(
                                          LangBlackboards.selectABlackboard,
                                          context);
                                      return;
                                    }
                                    await _bloc.changeDefaultBlackboard(
                                        caseItem: caseItemSnapshot.data,
                                        blackboardItem: _selectBlackboardItem);
                                  }
                                  Navigator.of(context).pop(true);
                                },
                              ))
                        ]);
                      });
                }),
            drawer: BlackboardsDrawerWidget(
              onPressed: (int caseId) async {
                if (caseId == widget.caseId) {
                  Navigator.pop(context);
                } else {
                  bool fromCopyPage = await App.navigateTo(
                      context, Routes.blackboardCopy, params: {
                    'caseId': caseId,
                    'copyToCaseId': widget.caseId,
                    'fromTemplatesPage': '1'
                  });
                  if (fromCopyPage ?? false) {
                    _bloc.getCaseById(widget.caseId);
                    Toast.show(LangBlackboards.copySuccessfully, context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  }
                }
              },
            )));
    // });
  }
}

class _BottomButton extends StatelessWidget {
  _BottomButton({@required this.caseItem, @required this.onPressed, Key key})
      : super(key: key);

  final CaseItem caseItem;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 40,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Text(
            LangBlackboards.useTheSelectedBlackboard,
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

typedef BlackboardsCallback(BlackboardItem item);

class _BlackboardsWidget extends StatefulWidget {
  _BlackboardsWidget(
      {@required this.caseItem,
      @required this.blackboards,
      @required this.onSelected,
      @required this.onPhotography,
      @required this.onUpdate,
      @required this.onDelete,
      Key key})
      : super(key: key);

  final CaseItem caseItem;
  final List<BlackboardItem> blackboards;
  final BlackboardsCallback onSelected;
  final BlackboardsCallback onPhotography;
  final BlackboardsCallback onUpdate;
  final BlackboardsCallback onDelete;
  @override
  _BlackboardsWidgetState createState() => _BlackboardsWidgetState();
}

class _BlackboardsWidgetState extends State<_BlackboardsWidget> {
  int _selectId;

  @override
  void initState() {
    widget.blackboards.forEach((item) {
      if (widget.caseItem.blackboardDefault == item.id) {
        _selectId = item.id;
        widget.onSelected(item);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<_BlackboardItemWidget> blackboards = [];
    widget.blackboards.forEach((item) {
      blackboards.add(_BlackboardItemWidget(
        caseItem: widget.caseItem,
        blackboardItem: item,
        selected: _selectId == item.id,
        onSelected: () async {
          widget.onSelected(item);
          setState(() {
            _selectId = item.id;
          });
        },
        onUpdate: () async {
          widget.onUpdate(item);
        },
        onPhotography: () async {
          widget.onPhotography(item);
        },
        onDelete: () async {
          if (await confirmDialog(
                context,
                titleText: LangBlackboards.blackboardDeleted,
                contentText: LangBlackboards.deletesTheSelectedBlackboard,
              ) ??
              false) {
            await widget.onDelete(item);
          }
        },
      ));
    });

    return ListView(children: blackboards);
  }
}

class _BlackboardItemWidget extends StatelessWidget {
  _BlackboardItemWidget(
      {@required this.caseItem,
      @required this.blackboardItem,
      @required this.selected,
      @required this.onPhotography,
      @required this.onSelected,
      @required this.onUpdate,
      @required this.onDelete,
      Key key})
      : super(key: key);

  final CaseItem caseItem;
  final BlackboardItem blackboardItem;
  final bool selected;
  final VoidCallback onPhotography;
  final VoidCallback onSelected;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    Widget templateWidget;
    switch (blackboardItem.blackboardId) {
      case 1:
        templateWidget = Template1Widget();
        break;
      case 2:
        templateWidget = Template2Widget();
        break;
      case 3:
        templateWidget = Template3Widget();
        break;
      case 4:
        templateWidget = Template4Widget();
        break;
      case 5:
        templateWidget = Template5Widget();
        break;
    }

    return Container(
        height: 180,
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colours.background, width: 1))),
        child: Flex(direction: Axis.horizontal, children: <Widget>[
          Expanded(
              flex: 8,
              child: Stack(children: [
                TemplateWidget(
                    caseName: caseItem.name,
                    blackboardItem: blackboardItem,
                    onPressed: () {
                      onSelected();
                    },
                    child: templateWidget),
                new Offstage(
                  offstage: !selected,
                  child: new Container(
                    margin: EdgeInsets.all(5.0),
                    width: 25.0,
                    height: 25.0,
                    child: Icon(
                      Icons.check_box,
                      color: Colors.blue,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.0),
                        color: Colors.white),
                  ),
                ),
              ])),
          Expanded(
              flex: 3,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: 70,
                        height: 37,
                        child: RaisedButton(
                            child: new Text(LangBlackboards.photography),
                            textColor: Colors.black,
                            color: Colors.grey[350],
                            onPressed: () {
                              onPhotography();
                            }),
                      ),
                      SizedBox(height: 15),
                      new Container(
                        width: 70,
                        height: 37,
                        child: RaisedButton(
                            child: new Text(LangBlackboards.update),
                            textColor: Colors.black,
                            color: Colors.grey[350],
                            onPressed: () {
                              onUpdate();
                            }),
                      ),
                      SizedBox(height: 15),
                      new Container(
                        width: 70,
                        height: 37,
                        child: RaisedButton(
                            child: new Text(LangBlackboards.delete),
                            textColor: Colors.black,
                            color: Colors.grey[350],
                            onPressed: () {
                              onDelete();
                            }),
                      ),
                    ],
                  )))
        ]));
  }
}
