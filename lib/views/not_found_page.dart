import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  NotFoundPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'NotFound',
        style: new TextStyle(fontSize: 25),
      )),
      body: Text('NotFound'),
    );
  }
}
