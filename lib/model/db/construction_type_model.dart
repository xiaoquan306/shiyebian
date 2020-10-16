import 'dart:io';

import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/db/db_model.dart';
import 'package:site_blackboard_app/model/db/photo_model.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';

class ConstructionTypeModel extends DbModel {
  @override
  String get tableName => 'constructionType';
//select constructionType.*,count(select * from photo where photo.constructionTypeId=constructionType.id)  from constructionType

  Future<List<ConstructionTypeItem>> findAll() async {
    var res = await (await db)
        .query(tableName, orderBy: '${ConstructionTypeColumn.name} desc');
    List<ConstructionTypeItem> list = res.isNotEmpty
        ? res.map((c) => ConstructionTypeItem(map: c)).toList()
        : [];
    return list;
  }

  Future<List<ConstructionTypeItem>> findByCaseId(int caseId) async {
    var res = await (await db).rawQuery(
        // " select constructionType.*,count(select * from photo where photo.constructionTypeId=constructionType.id) as photoCount from constructionType where caseId = $caseId "
        " select ct.*,p.photoCount from  constructionType  ct left join (select constructionTypeId,count(*) as photoCount from photo group by constructionTypeId) p on(ct.id = p.constructionTypeId) where caseId = $caseId order by isDefault desc,name desc");
    //
    // var res = await db.query(tableName,
    //     where: '${ConstructionTypeColumn.caseId} = ?', whereArgs: [caseId]);
    List<ConstructionTypeItem> list = res.isNotEmpty
        ? res.map((c) => ConstructionTypeItem(map: c)).toList()
        : [];
    return list;
  }

  Future<List<ConstructionTypeItem>> findByCaseIdOrder(
      bool nameController, int caseId, bool sortController) async {
    var res = List<dynamic>();
    if (nameController) {
      if (sortController) {
        res = await (await db).rawQuery(
            " select ct.*,p.photoCount from  constructionType  ct left join (select constructionTypeId,count(*) as photoCount from photo group by constructionTypeId) p on(ct.id = p.constructionTypeId) where caseId = $caseId order by name desc");
      } else {
        res = await (await db).rawQuery(
            " select ct.*,p.photoCount from  constructionType  ct left join (select constructionTypeId,count(*) as photoCount from photo group by constructionTypeId) p on(ct.id = p.constructionTypeId) where caseId = $caseId order by name asc");
      }
    } else {
      if (sortController) {
        res = await (await db).rawQuery(
            " select ct.*,p.photoCount from  constructionType  ct left join (select constructionTypeId,count(*) as photoCount from photo group by constructionTypeId) p on(ct.id = p.constructionTypeId) where caseId = $caseId order by updatedTime desc");
      } else {
        res = await (await db).rawQuery(
            " select ct.*,p.photoCount from  constructionType  ct left join (select constructionTypeId,count(*) as photoCount from photo group by constructionTypeId) p on(ct.id = p.constructionTypeId) where caseId = $caseId order by updatedTime asc");
      }
    }
    List<ConstructionTypeItem> list = res.isNotEmpty
        ? res.map((c) => ConstructionTypeItem(map: c)).toList()
        : [];
    return list;
  }

  Future<ConstructionTypeItem> get(int id) async {
    List<Map> maps = await (await db).query(tableName,
        where: '${ConstructionTypeColumn.id} = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return ConstructionTypeItem(map: maps.first);
    }

    return null;
  }

  Future<ConstructionTypeItem> insert(ConstructionTypeItem item) async {
    item.createdTime = DateTime.now().millisecondsSinceEpoch;
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    item.deletedTime = 0;

    item.id = await (await db).insert(tableName, item.toMapByDb());
    return item;
  }

  Future<int> getCount(int id) async {
    List<Map> maps = await (await db).query(tableName,
        columns: ["Count(1) as cnt"],
        where: '${ConstructionTypeColumn.id} = ?',
        whereArgs: [id]);
    if (maps.length > 0) return maps[0]["cnt"];
    return 0;
  }

  Future<int> getIdByDefault(int caseId) async {
    List<Map> _maps = await (await db).query(tableName,
        columns: ["id"],
        where:
            '${ConstructionTypeColumn.caseId} = ? and ${ConstructionTypeColumn.isDefault} = 1',
        whereArgs: [caseId]);
    if (_maps.length > 0) return _maps[0]["id"];
    return null;
  }

  Future<ConstructionTypeItem> getByName(int caseId, String name) async {
    if (name == null || name == '') {
      //保証されています。そして、「その他」のディレクトリしかありません
      if (await getIdByDefault(caseId) == null) {
        ConstructionTypeItem constructionTypeItem = new ConstructionTypeItem();
        constructionTypeItem.name = LangGlobal.other;
        constructionTypeItem.caseId = caseId;
        constructionTypeItem.isDefault = 1;
        await insert(constructionTypeItem);
      }
    }
    List<Map> maps = await (await db).query(tableName,
        columns: ["id"],
        where: '${ConstructionTypeColumn.caseId} = ? and name = ?',
        whereArgs: [
          caseId,
          name == null || name == '' ? LangGlobal.other : name
        ]);
    return maps.length > 0 ? ConstructionTypeItem(map: maps.first) : null;
  }

  Future<int> getIdByName(int caseId, String name) async {
    ConstructionTypeItem item = await getByName(caseId, name);
    return item?.id;
  }

  // Future<int> getNumByName(String name, int id) async {
  //   List<Map> maps = await (await db).query(tableName,
  //       columns: ["Count(id) as num"],
  //       where: '${ConstructionTypeColumn.name} = ?',
  //       whereArgs: [name.trim()]);
  //   if (maps.length > 0) return maps[0]["num"];
  //   return 0;
  // }

  update(ConstructionTypeItem item) async {
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    await (await db).update(tableName, item.toMapByDb(),
        where: '${ConstructionTypeColumn.id} = ?', whereArgs: [item.id]);
  }

  delete(ConstructionTypeItem item) async {
    String photoPath = await App.photoPath;
    List<PhotoItem> photoList =
        await PhotoModel().findByConstructionTypeId(item.id);
    await (await db).delete(tableName,
        where: '${ConstructionTypeColumn.id} = ?', whereArgs: [item.id]);
    photoList.forEach((element) {
      File(photoPath + "/" + element.name).delete();
    });
  }

  Future<List<PhotoItem>> getListByCaseId(int caseId) async {
    var res = await (await db).query(tableName,
        where: "${ConstructionTypeColumn.caseId} = ? ", whereArgs: [caseId]);
    List<ConstructionTypeItem> list = res.isNotEmpty
        ? res.map((c) => ConstructionTypeItem(map: c)).toList()
        : [];
    List<PhotoItem> listPhotoAll = new List<PhotoItem>();
    for (var i = 0; i < list.length; i++) {
      List<PhotoItem> listPhoto =
          await PhotoModel().findByConstructionTypeId(list[i].id);
      if (listPhoto.length > 0) {
        listPhotoAll.addAll(listPhoto);
      }
    }
    return listPhotoAll;
  }
}
