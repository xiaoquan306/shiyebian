import 'package:sqflite/sqflite.dart';

/// 基本的なデータベースの移行
abstract class DatabaseMigration {
  /// データベースの現在のバージョンを取得する
  int getVersion();

  /// データベースを作成する
  void onCreate(Database db, int version);

  /// データベースをアップグレードする
  void onUpgrade(Database db, int oldVersion, int newVersion);

  /// データベースのダウングレード
  void onDowngrade(Database db, int oldVersion, int newVersion);
}
