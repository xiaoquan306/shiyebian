import 'dart:async';

import 'package:flutter/material.dart';
import 'package:site_blackboard_app/config/color_define.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/utility/global_event.dart';
import 'package:site_blackboard_app/utility/log.dart';
import 'package:site_blackboard_app/utility/widget_tools.dart';
import 'package:site_blackboard_app/views/blackboard/template_widget.dart';

class Template5Widget extends StatefulWidget {
  @override
  _Template5WidgetState createState() => _Template5WidgetState();
}

class _Template5WidgetState extends State<Template5Widget> {
  TemplateWidget _templateWidget;
  BlackboardItem _blackboardItem;
  StreamSubscription _eventListen;

  @override
  void dispose() {
    if (_eventListen != null) {
      _eventListen.cancel();
      _eventListen = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_templateWidget == null) {
      _templateWidget = inheritedWidgetOf<TemplateWidget>(context);
      _blackboardItem = _templateWidget.blackboardItem;
      if (_templateWidget.useEvent && _eventListen == null) {
        _eventListen =
            globalEventBus.on<BlackboardChangeEvent>().listen((event) {
          if (mounted) {
            setState(() {
              _blackboardItem = event.blackboardItem;
            });
          }
        });
      }
    }

    return Container(
        padding: EdgeInsets.all(1),
        color: Colours.templateGreen,
        child: InkWell(
          onTap: () {
            if (_templateWidget.onPressed != null) {
              Log.info('Tap template5');
              _templateWidget.onPressed();
            }
          },
          child: Flex(direction: Axis.vertical, children: <Widget>[
            // constructionName
            Expanded(
                flex: 1,
                child: Flex(direction: Axis.horizontal, children: <Widget>[
                  Expanded(
                    flex: TemplateCellFlex.left,
                    child: TemplateCellWidget(
                      type: TemplateCellType.TITLE,
                      text: LangBlackboardTemplates.constructionName,
                      border: [TemplateCellBorder.LEFT, TemplateCellBorder.TOP],
                    ),
                  ),
                  Expanded(
                      flex: TemplateCellFlex.right,
                      child: TemplateCellWidget(
                        type: TemplateCellType.TEXT,
                        text: _templateWidget.caseName,
                        border: [
                          TemplateCellBorder.LEFT,
                          TemplateCellBorder.TOP,
                          TemplateCellBorder.RIGHT,
                        ],
                      )),
                ])),
            // typeOfWork
            Expanded(
                flex: 1,
                child: Flex(direction: Axis.horizontal, children: <Widget>[
                  Expanded(
                    flex: TemplateCellFlex.left,
                    child: TemplateCellWidget(
                      type: TemplateCellType.TITLE,
                      text: LangBlackboardTemplates.constructionType,
                      border: [TemplateCellBorder.LEFT, TemplateCellBorder.TOP],
                    ),
                  ),
                  Expanded(
                      flex: TemplateCellFlex.right,
                      child: TemplateCellWidget(
                        type: TemplateCellType.TEXT,
                        text: _blackboardItem.constructionType,
                        border: [
                          TemplateCellBorder.LEFT,
                          TemplateCellBorder.TOP,
                          TemplateCellBorder.RIGHT,
                        ],
                      )),
                ])),
            // shootingPlace
            Expanded(
                flex: 1,
                child: Flex(direction: Axis.horizontal, children: <Widget>[
                  Expanded(
                    flex: TemplateCellFlex.left,
                    child: TemplateCellWidget(
                      type: TemplateCellType.TITLE,
                      text: LangBlackboardTemplates.shootingPlace,
                      border: [TemplateCellBorder.LEFT, TemplateCellBorder.TOP],
                    ),
                  ),
                  Expanded(
                      flex: TemplateCellFlex.right,
                      child: TemplateCellWidget(
                        type: TemplateCellType.TEXT,
                        text: _blackboardItem.shootingSpot,
                        border: [
                          TemplateCellBorder.LEFT,
                          TemplateCellBorder.TOP,
                          TemplateCellBorder.RIGHT,
                        ],
                      )),
                ])),
            // shootingContent
            Expanded(
                flex: 3,
                child: Flex(direction: Axis.horizontal, children: <Widget>[
                  Expanded(
                    flex: TemplateCellFlex.left,
                    child: TemplateCellWidget(
                      type: TemplateCellType.TITLE,
                      text: LangBlackboardTemplates.shootingContent,
                      border: [TemplateCellBorder.LEFT, TemplateCellBorder.TOP],
                    ),
                  ),
                  Expanded(
                      flex: TemplateCellFlex.right,
                      child: TemplateCellWidget(
                        type: TemplateCellType.CONTENT,
                        text: _blackboardItem.title,
                        border: [
                          TemplateCellBorder.LEFT,
                          TemplateCellBorder.TOP,
                          TemplateCellBorder.RIGHT,
                        ],
                      )),
                ])),
            // contractor
            Expanded(
                flex: 1,
                child: Flex(direction: Axis.horizontal, children: <Widget>[
                  Expanded(
                    flex: TemplateCellFlex.left,
                    child: TemplateCellWidget(
                      type: TemplateCellType.TITLE,
                      text: LangBlackboardTemplates.contractor,
                      border: [
                        TemplateCellBorder.LEFT,
                        TemplateCellBorder.TOP,
                        TemplateCellBorder.BOTTOM
                      ],
                    ),
                  ),
                  Expanded(
                      flex: TemplateCellFlex.right,
                      child: TemplateCellWidget(
                        type: TemplateCellType.TEXT,
                        text: _blackboardItem.contructor,
                        border: [
                          TemplateCellBorder.LEFT,
                          TemplateCellBorder.RIGHT,
                          TemplateCellBorder.TOP,
                          TemplateCellBorder.BOTTOM,
                        ],
                      )),
                ])),
          ]),
        ));
  }
}
