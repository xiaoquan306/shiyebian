import 'package:flutter/material.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/blackboard/blackboards_copy_bloc.dart';
import 'package:site_blackboard_app/config/color_define.dart';
import 'package:site_blackboard_app/config/icon_font.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/views/blackboard/template1_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template2_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template3_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template4_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template5_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template_widget.dart';
import 'package:site_blackboard_app/views/widget/dialog_widget.dart';
import 'package:toast/toast.dart';

class BlackboardsCopyPage extends StatefulWidget {
  BlackboardsCopyPage(
      {this.caseId,
      this.copyToCaseId,
      this.fromBlackboardsPage = false,
      Key key})
      : super(key: key);
  final int caseId;
  final int copyToCaseId;
  final bool fromBlackboardsPage;
  @override
  _BlackboardsCopyPageState createState() => _BlackboardsCopyPageState();
}

class _BlackboardsCopyPageState extends State<BlackboardsCopyPage> {
  BlackboardsCopyBloc _bloc;
  List<int> selectedIdsToCase = [];
  var caseName;
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = BlackboardsCopyBloc();
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
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          actions: [
            StreamBuilder(
                stream: _bloc.fetchByCaseIdStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<BlackboardItem>> blackboardsSnapshot) {
                  if (!blackboardsSnapshot.hasData) {
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
                          child: Text(LangBlackboards.bulk),
                          onPressed: blackboardsSnapshot.data.length > 0
                              ? () async {
                                  try {
                                    await (await App.db).execute("BEGIN;");
                                    if (await confirmDialog(
                                          context,
                                          titleText:
                                              LangBlackboards.blackboardCopy,
                                          contentText: caseName +
                                              LangBlackboards
                                                  .copySelectedBlackboard,
                                        ) ??
                                        false) {
                                      globalKey.currentState.selectAll();
                                      await _bloc.copyMultiple(
                                          selectedIdsToCase,
                                          widget.copyToCaseId);
                                      if (widget.fromBlackboardsPage == true) {
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                      } else {
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                        Navigator.pop(context, true);
                                      }
                                    }
                                    await (await App.db).execute("COMMIT;");
                                  } catch (e) {
                                    await (await App.db).execute("ROLLBACK;");
                                    throw (e);
                                  }
                                }
                              : null));
                }),
          ],
        ),
//
        body: StreamBuilder(
          stream: _bloc.getCaseByIdStream,
          builder:
              (BuildContext context, AsyncSnapshot<CaseItem> caseItemSnapshot) {
            if (!caseItemSnapshot.hasData) {
              return Container();
            }
            _bloc.fetchByCaseId(caseItemSnapshot.data.id);

            return StreamBuilder(
              stream: _bloc.fetchByCaseIdStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<BlackboardItem>> blackboardsSnapshot) {
                if (!blackboardsSnapshot.hasData) {
                  return Container();
                }
                caseName = caseItemSnapshot.data.name;
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      color: Colours.background,
                      child: Text(
                          '${LangBlackboards.caseName} : ${caseItemSnapshot.data.name}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      color: Colours.background,
                      child: Text('${LangBlackboards.copyBlackboard} '),
                    ),
                    Expanded(
                        child: _BlackboardsWidget(
                      key: globalKey,
                      caseItem: caseItemSnapshot.data,
                      blackboards: blackboardsSnapshot.data,
                      onSelected: (List ids) async {
                        selectedIdsToCase = ids;
                      },
                      onCopy: (BlackboardItem item) async {
                        await _bloc.copy(item.id, widget.copyToCaseId);
                        if (widget.fromBlackboardsPage == true) {
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                        } else {
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                        }
                      },
                    )),
                    Offstage(
                        offstage: false,
                        child: _BottomButton(
                          caseItem: caseItemSnapshot.data,
                          onPressed: () async {
                            if (selectedIdsToCase.length == 0) {
                              Toast.show(LangBlackboards.noBlackboard, context);
                              return;
                            }
                            await _bloc.copyMultiple(
                                selectedIdsToCase, widget.copyToCaseId);
                            if (widget.fromBlackboardsPage == true) {
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                            } else {
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                              Navigator.pop(context, true);
                            }
                          },
                        ))
                  ],
                );
              },
            );
          },
        ));
  }
}

typedef BlackboardsCallback(BlackboardItem item);
typedef BlackboardsCopyBatchCallback(List<int> ids);
GlobalKey<_BlackboardsWidgetState> globalKey = GlobalKey();

class _BlackboardsWidget extends StatefulWidget {
  _BlackboardsWidget({
    @required this.caseItem,
    @required this.blackboards,
    @required this.onSelected,
    @required this.onCopy,
    Key key,
  }) : super(key: key);

  final CaseItem caseItem;

  final List<BlackboardItem> blackboards;
  final BlackboardsCopyBatchCallback onSelected;
  final BlackboardsCallback onCopy;

  @override
  _BlackboardsWidgetState createState() => _BlackboardsWidgetState();
}

class _BlackboardsWidgetState extends State<_BlackboardsWidget> {
  List<int> selectedIds = [];

  @override
  void initState() {
    widget.blackboards.forEach((item) {});
    super.initState();
  }

  selectAll() {
    widget.blackboards.forEach((item) {
      if (selectedIds.contains(item.id)) {
      } else {
        selectedIds.add(item.id);
      }
    });

    widget.onSelected(selectedIds);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<_BlackboardItemWidget> blackboards = [];
    widget.blackboards.forEach((item) {
      blackboards.add(_BlackboardItemWidget(
        caseItem: widget.caseItem,
        blackboardItem: item,
        selected: selectedIds.contains(item.id),
        onSelected: () {
          if (selectedIds.contains(item.id)) {
            selectedIds.remove(item.id);
          } else {
            selectedIds.add(item.id);
          }
          widget.onSelected(selectedIds);
          setState(() {});
        },
        onCopy: () async {
          await widget.onCopy(item);
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
      @required this.onSelected,
      @required this.onCopy,
      @required this.selected,
      Key key})
      : super(key: key);

  final bool selected;
  final CaseItem caseItem;
  final BlackboardItem blackboardItem;
  final VoidCallback onSelected;

  final VoidCallback onCopy;

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
              flex: 5,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 3),
                      new Container(
                        width: 120,
                        height: 30,
                        child: RaisedButton(
                            child: new Text(LangBlackboards.copy),
                            textColor: Colors.black,
                            color: Colors.grey[350],
                            onPressed: () {
                              onCopy();
                            }),
                      ),
                    ],
                  )))
        ]));
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
            LangBlackboards.useTheCopiedBlackboard,
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
