import 'package:flutter/material.dart';

T inheritedWidgetOf<T extends InheritedWidget>(BuildContext context) {
  return context.dependOnInheritedWidgetOfExactType<T>();
}
