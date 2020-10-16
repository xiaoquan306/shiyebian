import 'package:site_blackboard_app/model/db/db_model.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';

class BlackboardModel extends DbModel {
  @override
  String get tableName => 'blackboard';

  Future<List<BlackboardItem>> findByCaseId(int caseId) async {
    List<Map> res = await (await db).query(tableName,
        where: '${BlackboardColumn.caseId} = ?',
        whereArgs: [caseId],
        orderBy: '${BlackboardColumn.id} desc');

    return res.isNotEmpty
        ? res.map((c) => BlackboardItem(map: c)).toList()
        : [];
  }

  Future<List<BlackboardItem>> findAll() async {
    List<Map> res = await (await db).query(tableName);

    return res.isNotEmpty
        ? res.map((c) => BlackboardItem(map: c)).toList()
        : [];
  }

  Future<BlackboardItem> get(int id) async {
    List<Map> res = await (await db)
        .query(tableName, where: '${BlackboardColumn.id} = ?', whereArgs: [id]);

    if (res.length > 0) {
      return BlackboardItem(map: res.first);
    }

    return null;
  }

  BlackboardItem getDefault() {
    return new BlackboardItem();
  }

  Future<int> initBlackboard(int caseId) async {
    BlackboardItem item = new BlackboardItem();
    item.createdTime = DateTime.now().millisecondsSinceEpoch;
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    item.deletedTime = 0;
    item.caseId = caseId;
    item.blackboardId = 1;
    item.id = await (await db).insert(tableName, item.toMap());
    return item.id;
  }

  Future<BlackboardItem> insert(BlackboardItem item) async {
    item.createdTime = DateTime.now().millisecondsSinceEpoch;
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    item.deletedTime = 0;
    item.id = await (await db).insert(tableName, item.toMap());
    return item;
  }

  Future<BlackboardItem> getNextByCaseId(int caseId) async {
    List<Map> maps = await (await db).query(tableName,
        where: '${BlackboardColumn.caseId} = ?', whereArgs: [caseId]);

    if (maps.length > 0) {
      return BlackboardItem(map: maps.first);
    }

    return null;
  }

  update(BlackboardItem item) async {
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    await (await db).update(tableName, item.toMap(),
        where: '${BlackboardColumn.id} = ?', whereArgs: [item.id]);
  }

  delete(int id) async {
    await (await db).delete(tableName,
        where: '${BlackboardColumn.id} = ?', whereArgs: [id]);
  }

  deleteByCaseId(int caseId) async {
    await (await db).delete(tableName,
        where: '${BlackboardColumn.caseId} = ?', whereArgs: [caseId]);
  }
}
