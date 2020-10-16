import 'package:path/path.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:sqflite/sqflite.dart';

import '../log.dart';
import 'database_migration.dart';

/// データベースアシスタント
class DatabaseHelper {
  final String _name;
  final DatabaseMigration _migration;
  Database _db;

  DatabaseHelper(this._name, this._migration);

  /// sqfliteインスタンスを取得する
  Database get db => _db;

  /// データベースを開く
  Future<void> open() async {
    String path = await _getPath();
    _db = await openDatabase(path,
        version: _migration.getVersion(),
        onCreate: _migration.onCreate,
        onUpgrade: _migration.onUpgrade,
        onDowngrade: _migration.onDowngrade);
    _db.execute("PRAGMA foreign_keys = ON");
    Log.info('Database opened: $path');
  }

  /// データベースを閉じます
  Future<void> close() async {
    _db?.close();
    _db = null;
  }

  Future<String> _getPath() async {
    return join((await App.supportDirectory).path, _name);
  }
}
