import 'package:site_blackboard_app/utility/db/database_create_table.dart';
import 'package:sqflite/sqflite.dart';

import '../log.dart';
import 'database_migration.dart';

/// 小黒板データベースの移行
class BlackBoardDatabaseMigration implements DatabaseMigration {
  static const int VERSION_CURRENT = 4;

  /// データベースの現在のバージョンを取得する
  @override
  int getVersion() {
    return VERSION_CURRENT;
  }

  /// データベースを作成する
  @override
  void onCreate(Database db, int version) async {
    Batch batch = db.batch();
    DatabaseCreateTable.createCases(batch);
    DatabaseCreateTable.createBlackboard(batch);
    DatabaseCreateTable.createPhoto(batch);
    DatabaseCreateTable.createConstructionType(batch);
    DatabaseCreateTable.initCase(batch);
    DatabaseCreateTable.initBlackboard(batch);
    DatabaseCreateTable.initConstructionType(batch);
    await batch.commit();
    Log.info('Created database version: $version');
  }

  /// データベースをアップグレードする
  @override
  void onUpgrade(Database db, int oldVersion, int newVersion) async {
    Log.info('Upgraded the database version from $oldVersion to $newVersion');
  }

  /// データベースのダウングレード
  @override
  void onDowngrade(Database db, int oldVersion, int newVersion) async {
    Log.warning('Database demotion cannot be performed.');
    // Batch batch = db.batch();
    // if (newVersion == 1) {
    //   batch.execute('alter table blackboard add constructionTypeId integer');
    // }
    // await batch.commit();
  }
}
