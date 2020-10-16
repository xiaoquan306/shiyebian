import 'package:site_blackboard_app/app/app.dart';
import 'package:sqflite/sqflite.dart';

abstract class DbModel {
  Future<Database> get db async => await App.db;

  String get tableName;
}
