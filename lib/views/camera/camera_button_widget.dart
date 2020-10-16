import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:site_blackboard_app/utility/widget_tools.dart';

class CameraButtonWidget extends InheritedWidget {
  CameraButtonWidget(
      {@required this.color,
      @required this.disableColor,
      @required this.text,
      @required this.orientation,
      @required this.onPressed,
      Key key})
      : super(key: key, child: _CameraButtonWidget());

  final Color color;
  final Color disableColor;
  final String text;
  final DeviceOrientation orientation;
  final VoidCallback onPressed;

  @override
  bool updateShouldNotify(CameraButtonWidget old) =>
      this.text != old.text || this.orientation != old.orientation;
}

class _CameraButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cameraButtonWidget = inheritedWidgetOf<CameraButtonWidget>(context);
    return new Expanded(
      child: new Container(
        height: 60,
        child: new RaisedButton(
          color: cameraButtonWidget.color,
          disabledColor: cameraButtonWidget.disableColor,
          textColor: Colors.white,
          child: RotatedBox(
            quarterTurns:
                cameraButtonWidget.orientation == DeviceOrientation.portraitUp
                    ? 0
                    : (cameraButtonWidget.orientation ==
                            DeviceOrientation.landscapeLeft
                        ? 3
                        : (cameraButtonWidget.orientation ==
                                DeviceOrientation.portraitDown
                            ? 2
                            : 1)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(cameraButtonWidget.text,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 38,
                      )),
                )
              ],
            ),
          ),
          onPressed: cameraButtonWidget.onPressed,
        ),
      ),
    );
  }
}
