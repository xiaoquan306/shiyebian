import 'dart:async';

import 'package:flutter/material.dart';
import 'package:site_blackboard_app/config/color_define.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/utility/global_event.dart';
import 'package:site_blackboard_app/utility/log.dart';
import 'package:site_blackboard_app/utility/widget_tools.dart';
import 'package:site_blackboard_app/views/blackboard/template_widget.dart';

class Template1Widget extends StatefulWidget {
  @override
  _Template1WidgetState createState() => _Template1WidgetState();
}

class _Template1WidgetState extends State<Template1Widget> {
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
              Log.info('Tap template1');
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
            // content
            Expanded(
                flex: 6,
                child: TemplateCellWidget(
                    type: TemplateCellType.CONTENT,
                    text: _blackboardItem.title,
                    border: [TemplateCellBorder.ALL]))
          ]),
        ));
  }
}
