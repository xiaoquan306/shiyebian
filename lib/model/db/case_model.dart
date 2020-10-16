import 'dart:io';

import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/db/blackboard_model.dart';
import 'package:site_blackboard_app/model/db/construction_type_model.dart';
import 'package:site_blackboard_app/model/db/db_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';

class CaseModel extends DbModel {
  @override
  String get tableName => 'cases';

  Future<List<CaseItem>> findAll() async {
    var res =
        await (await db).query(tableName, orderBy: '${CaseColumn.id} desc');
    List<CaseItem> list =
        res.isNotEmpty ? res.map((c) => CaseItem(map: c)).toList() : [];
    return list;
  }

  Future<List<CaseItem>> findByName(name) async {
    var res = await (await db).query(tableName,
        where: "${CaseColumn.name} like ? ",
        whereArgs: ['%' + (name ?? '') + '%'],
        orderBy: '${CaseColumn.name} asc');
    // orderBy: '${CaseColumn.name}  COLLATE UNICODE asc');
    List<CaseItem> list =
        res.isNotEmpty ? res.map((c) => CaseItem(map: c)).toList() : [];
    return list;
  }

  Future<bool> getCaseName(String name) async {
    var res = await (await db)
        .query(tableName, where: '${CaseColumn.name} = ?', whereArgs: [name]);
    List<CaseItem> list =
        res.isNotEmpty ? res.map((c) => CaseItem(map: c)).toList() : [];
    if (list.length > 0) return false;
    return true;
  }

  Future<bool> getCaseNameEdit(String name, int caseId) async {
    var res = await (await db).query(tableName,
        where: '${CaseColumn.name} = ? and ${CaseColumn.id} <> ?',
        whereArgs: [name, caseId]);
    List<CaseItem> list =
        res.isNotEmpty ? res.map((c) => CaseItem(map: c)).toList() : [];
    if (list.length > 0) return false;
    return true;
  }

  Future<CaseItem> get(int id) async {
    List<Map> maps = await (await db)
        .query(tableName, where: '${CaseColumn.id} = ?', whereArgs: [id]);
    if (maps.length > 0) {
      await updateActive(CaseItem(map: maps.first));
      return CaseItem(map: maps.first);
    }

    return null;
  }

  Future<CaseItem> getPre(int id) async {
    List<Map> maps = await (await db).query(tableName,
        where: '${CaseColumn.id} < ?',
        whereArgs: [id],
        orderBy: '${CaseColumn.id} desc');
    if (maps.length > 0) {
      await updateActive(CaseItem(map: maps.first));
      return CaseItem(map: maps.first);
    }

    return null;
  }

  Future<int> getCount() async {
    List<Map> maps =
        await (await db).query(tableName, columns: ["Count(1) as cnt"]);
    if (maps.length > 0) return maps[0]["cnt"];
    return 0;
  }

  Future<CaseItem> insert(CaseItem item) async {
    item.createdTime = DateTime.now().millisecondsSinceEpoch;
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    item.deletedTime = 0;
    item.activated = 0;
    item.id = await (await db).insert(tableName, item.toMap());
    int num = await getCount();
    if (item.id > 1 && num > 1) {
      CaseItem info = await getPre(item.id);
      item.savePosition = info.savePosition;
      item.useBlackboard = info.useBlackboard;
      item.saveOriginal = info.saveOriginal;
      item.tamperProof = info.tamperProof;
      await update(item);
    }
    var blackboardId = await BlackboardModel().initBlackboard(item.id);
    item.blackboardDefault = blackboardId;
    await (await db).update(tableName, item.toMap(),
        where: '${CaseColumn.id} = ?', whereArgs: [item.id]);
    ConstructionTypeItem folderItem = new ConstructionTypeItem();
    folderItem.caseId = item.id;
    folderItem.name = LangGlobal.other;
    folderItem.isDefault = 1;
    await ConstructionTypeModel().insert(folderItem);
    //トランザクションのロールバックをテストする
    // List<Map> maps =
    //     await (await db).query('case', columns: ["Count(1) as cnt"]);
    return item;
  }

  update(CaseItem item) async {
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    item.useBlackboard = 1;
    await (await db).update(tableName, item.toMap(),
        where: '${CaseColumn.id} = ?', whereArgs: [item.id]);
  }

  updateSetting(CaseItem item) async {
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> settingMap = {
      'savePosition': item.savePosition,
      'useBlackboard': item.useBlackboard,
      'saveOriginal': item.saveOriginal,
      'tamperProof': item.tamperProof
    };
    await (await db).update(tableName, settingMap);
  }

  updateActive(CaseItem item) async {
    await (await db)
        .rawUpdate("update $tableName set ${CaseColumn.activated} = ? ", [0]);
    item.activated = 1;
    await (await db).update(tableName, item.toMap(),
        where: '${CaseColumn.id} = ?', whereArgs: [item.id]);
  }

  delete(int id) async {
    String photoPath = await App.photoPath;
    List<PhotoItem> photoList =
        await ConstructionTypeModel().getListByCaseId(id);
    await (await db)
        .delete(tableName, where: '${CaseColumn.id} = ?', whereArgs: [id]);
    if (photoList.length > 0) {
      photoList.forEach((element) {
        File(photoPath + "/" + element.name).delete();
      });
    }
  }
}
