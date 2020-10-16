import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/utility/jpeg_helper.dart';
import 'package:site_blackboard_app/views/blackboard/template1_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template2_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template3_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template4_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template5_widget.dart';
import 'package:site_blackboard_app/views/blackboard/template_widget.dart';

GlobalKey<_CameraBlackboardWidget> getPhotoKey = GlobalKey();

class CameraBlackboardWidget extends StatefulWidget {
  final DeviceOrientation orientation;
  final int id;
  final String caseName;
  final BlackboardItem blockBoardItem;
  final VoidCallback onPress;
  CameraBlackboardWidget(
      {Key key,
      this.id,
      this.caseName,
      this.blockBoardItem,
      this.orientation,
      this.onPress})
      : super(key: key);
  @override
  _CameraBlackboardWidget createState() => _CameraBlackboardWidget();
}

class _CameraBlackboardWidget extends State<CameraBlackboardWidget> {
  double width;
  double height;
  GlobalKey globalKey = new GlobalKey();

  double _x;
  double _y;
  double _width;
  double _height;
  double _tmpW;
  double _tmpH;
  Offset _lastOffset;
  double _ratio;
  double _bgW;
  double _bgH;
  bool initY = false;
  bool cameraIn;

  @override
  void initState() {
    super.initState();

    _width = 170;
    _height = 110;
    _x = 30.0;
    _y = 0.0;
    _ratio = _width / _height;
    _tmpW = _width;
    _tmpH = _height;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        this.width = constraints.biggest.width;
        this.height = constraints.biggest.height;
        if (!initY) {
          initY = true;
          _y = this.height - 30.0 - this._height;
        }

        if (_x > (this.width - this._width)) {
          _x = (this.width - this._width);
        }
        if (_y > (this.height - this._height)) {
          _y = (this.height - this._height);
        }
        return Stack(
          children: <Widget>[
            Positioned(
              left: _x,
              top: _y,
              child: GestureDetector(
                onScaleStart: scaleStartEvent,
                onScaleUpdate: scaleUpdateEvent,
                onScaleEnd: scaleEndEvent,
                child: RepaintBoundary(
                  key: globalKey,
                  child: new Container(
                    width: this._width,
                    height: this._height,
                    child: TemplateWidget(
                      caseName: widget.caseName,
                      blackboardItem: widget.blockBoardItem,
                      onPressed: widget.onPress,
                      textAutoSize: true,
                      group: AutoSizeGroup(),
                      key: UniqueKey(),
                      child: widget.blockBoardItem.blackboardId == 1
                          ? Template1Widget()
                          : (widget.blockBoardItem.blackboardId == 2
                              ? Template2Widget()
                              : (widget.blockBoardItem.blackboardId == 3
                                  ? Template3Widget()
                                  : (widget.blockBoardItem.blackboardId == 4
                                      ? Template4Widget()
                                      : Template5Widget()))),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<BlackboardPosition> captureTemp(String tmpFilePath) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    BlackboardPosition _position = new BlackboardPosition();
    ui.Image tmp =
        await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);

    im.Image imgPng = im.readPng(
        (await tmp.toByteData(format: ui.ImageByteFormat.png))
            .buffer
            .asUint8List());

    _position.img = imgPng; //im.readJpg(im.encodeJpg(imgPng, quality: 70));
    return await getPosition(_position, tmpFilePath);
  }

  Future<BlackboardPosition> getPosition(
      BlackboardPosition position, String tmpFilePath) async {
    im.Image srcImg = im.decodeJpg(File(tmpFilePath).readAsBytesSync());
    im.Image dstImg = JpegHelper().getRealImage(srcImg);
    double lprW = this._width / this.width;
    num wTmp = dstImg.width * lprW;
    position.width = wTmp.toInt();
    num hTmp = position.width * this._height / this._width;
    position.height = hTmp.toInt();
    num xTmp = _x * dstImg.width / this.width;
    num yTmp = _y * dstImg.height / this.height;
    position.point = Point(xTmp.toInt(), yTmp.toInt());
    return position;
  }

  void getBgInfo() {
    _bgW = this.width;
    _bgH = this.height;
  }

  void scaleStartEvent(ScaleStartDetails details) {
    _tmpW = _width;
    _tmpH = _height;
    _lastOffset = details.focalPoint;
    getBgInfo();
  }

  void scaleUpdateEvent(ScaleUpdateDetails details) {
    setState(() {
      _width = _tmpW * details.scale;
      _height = _tmpH * details.scale;

      if (widget.orientation == DeviceOrientation.portraitUp) {
        _x += (details.focalPoint.dx - _lastOffset.dx);
        _y += (details.focalPoint.dy - _lastOffset.dy);
      } else if (widget.orientation == DeviceOrientation.landscapeRight) {
        _x += (details.focalPoint.dy - _lastOffset.dy);
        _y -= (details.focalPoint.dx - _lastOffset.dx);
      } else if (widget.orientation == DeviceOrientation.portraitDown) {
        _x -= (details.focalPoint.dx - _lastOffset.dx);
        _y -= (details.focalPoint.dy - _lastOffset.dy);
      } else {
        _y += (details.focalPoint.dx - _lastOffset.dx);
        _x -= (details.focalPoint.dy - _lastOffset.dy);
      }

      if (_width > _bgW) {
        _width = _bgW;
        _height = _width / _ratio;
      }
      if (_height > _bgH) {
        _height = _bgH;
        _width = _height * _ratio;
      }
      if (_x < 0) _x = 0;
      if (_y < 0) _y = 0;
      if (_x > _bgW - _width) _x = _bgW - _width;
      if (_y > _bgH - _height) _y = _bgH - _height;
      _lastOffset = details.focalPoint;
    });
  }

  void scaleEndEvent(ScaleEndDetails details) {
    _tmpW = _width;
    _tmpH = _height;
    if (_width < 100) {
      _width = 100;
      _height = _width / _ratio;
    }
    if (_height < 67) {
      _height = 67;
      _width = _height * _ratio;
    }
  }
}

class BlackboardPosition {
  im.Image img;
  Point point;
  int width;
  int height;

  BlackboardPosition({this.point, this.width, this.height});
}
