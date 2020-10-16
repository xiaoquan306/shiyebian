import 'package:flutter/material.dart';
import 'package:site_blackboard_app/bloc/blackboard/blackboards_drawer_bloc.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';

typedef PressedCallback(int caseId);

class BlackboardsDrawerWidget extends StatefulWidget {
  BlackboardsDrawerWidget({@required this.onPressed, Key key})
      : super(key: key);

  final PressedCallback onPressed;

  @override
  _BlackboardsDrawerWidgetState createState() =>
      _BlackboardsDrawerWidgetState();
}

class _BlackboardsDrawerWidgetState extends State<BlackboardsDrawerWidget> {
  BlackboardsDrawerBloc _bloc;
  TextEditingController _titleCtl;

  @override
  void dispose() {
    _bloc.dispose();
    _titleCtl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = BlackboardsDrawerBloc();
    _bloc.fetchByName(null);
    _titleCtl = TextEditingController();
    _titleCtl.addListener(() {
      _bloc.fetchByName(_titleCtl.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 4 / 7;

    return Container(
        width: width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              enableInteractiveSelection: true,
              controller: _titleCtl,
              autofocus: false,
              decoration: InputDecoration(
                hintText: LangBlackboards.search,
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              height: 30,
              color: Color.fromRGBO(230, 230, 230, 1),
            ),
            Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                      stream: _bloc.fetchByNameStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CaseItem>> snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        List<Widget> _list = List();
                        snapshot.data.forEach((caseItem) {
                          _list.add(Container(
                            height: 50,
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(color: Colors.grey[500]),
                                ]),
                            child: InkWell(
                              child: Text(
                                caseItem.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                // this.curSltId = null;
                                // _caseBloc.getByIdBlackboardBrowse(item1.id);
                                // selec'tFalg = true;
                                // if (item1.id == widget.id) {
                                //   selectFalg = false;
                                // }'
                                //     Navigator.of(context).pop();
                                widget.onPressed(caseItem.id);
                              },
                            ),
                          ));
                        });
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ListView(children: _list),
                              ),
                              // SizedBox(
                              //   width: width - 10,
                              //   child: new RaisedButton(
                              //     elevation: 2.0,
                              //     child: Text(LangBlackboards.showAll),
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(5.0)),
                              //     onPressed: () => Navigator.of(context)
                              //         .pop(), // タッチすると、案件リストが左にスライドして非表示になる。        すべての黒板が表示される。
                              //   ),
                              // )
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          ],
        ));
  }
}
