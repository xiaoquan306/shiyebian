import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/utility/widget_tools.dart';

class TemplateWidget extends InheritedWidget {
  TemplateWidget(
      {@required this.caseName,
      @required this.blackboardItem,
      this.onPressed,
      this.useEvent = false,
      this.textAutoSize = false,
      this.group,
      Key key,
      @required Widget child})
      : super(key: key, child: child);

  final String caseName;
  final BlackboardItem blackboardItem;
  final VoidCallback onPressed;
  final bool useEvent;
  final bool textAutoSize;
  final AutoSizeGroup group;

  @override
  bool updateShouldNotify(TemplateWidget old) =>
      caseName != old.caseName ||
      blackboardItem != old.blackboardItem ||
      onPressed != old.onPressed;
}

enum TemplateCellBorder { ALL, TOP, BOTTOM, LEFT, RIGHT }
enum TemplateCellType { TITLE, TEXT, CONTENT }

abstract class TemplateCellFlex {
  static final int left = 4;
  static final int right = 8;
}

class TemplateCellWidget extends StatelessWidget {
  TemplateCellWidget(
      {@required this.text,
      @required this.type,
      @required this.border,
      this.ellipsis = true});

  final String text;
  final TemplateCellType type;
  final List<TemplateCellBorder> border;
  final bool ellipsis;
  // final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    TemplateWidget templateWidget = inheritedWidgetOf<TemplateWidget>(context);
    bool textAutoSize = templateWidget.textAutoSize;
    AutoSizeGroup autoSizeGroup = templateWidget.group;

    final borderSet = Border(
      top: border.contains(TemplateCellBorder.ALL) ||
              border.contains(TemplateCellBorder.TOP)
          ? BorderSide(color: Colors.white, width: 1)
          : BorderSide.none,
      bottom: border.contains(TemplateCellBorder.ALL) ||
              border.contains(TemplateCellBorder.BOTTOM)
          ? BorderSide(color: Colors.white, width: 1)
          : BorderSide.none,
      left: border.contains(TemplateCellBorder.ALL) ||
              border.contains(TemplateCellBorder.LEFT)
          ? BorderSide(color: Colors.white, width: 1)
          : BorderSide.none,
      right: border.contains(TemplateCellBorder.ALL) ||
              border.contains(TemplateCellBorder.RIGHT)
          ? BorderSide(color: Colors.white, width: 1)
          : BorderSide.none,
    );

    Alignment alignment;
    EdgeInsets padding;
    StatelessWidget textSet;
    switch (type) {
      case TemplateCellType.TITLE:
        alignment = Alignment.center;
        padding = EdgeInsets.all(0);
        textSet = textAutoSize
            ? TemplateCellTextAutoSizeWidget(
                text,
                maxLines: 1,
                group: autoSizeGroup,
              )
            : TemplateCellTextWidget(text, maxLines: 1);
        break;
      case TemplateCellType.TEXT:
        alignment = Alignment.centerLeft;
        // padding = EdgeInsets.all(0);
        padding = EdgeInsets.fromLTRB(6, 0, 6, 0);
        textSet = textAutoSize
            ? TemplateCellTextAutoSizeWidget(
                text,
                maxLines: 1,
              )
            : TemplateCellTextWidget(text, maxLines: 1);
        break;
      default: // TemplateCellType.CONTENT
        alignment = Alignment.topLeft;
        // padding = EdgeInsets.all(0);
        padding = EdgeInsets.all(6);
        textSet = TemplateCellTextAutoSizeWidget(
          text,
        );
    }

    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: padding,
        alignment: alignment,
        decoration: BoxDecoration(
          border: borderSet,
        ),
        child: textSet);
  }
}

class TemplateCellTextWidget extends StatelessWidget {
  TemplateCellTextWidget(this.text, {this.maxLines, Key key}) : super(key: key);

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: Colors.white, fontSize: 13),
    );
  }
}

class TemplateCellTextAutoSizeWidget extends StatelessWidget {
  TemplateCellTextAutoSizeWidget(this.text,
      {this.maxLines, this.group, Key key})
      : super(key: key);

  final String text;
  final int maxLines;
  final AutoSizeGroup group;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text ?? '',
      maxLines: maxLines,
      minFontSize: 1,
      group: group,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
