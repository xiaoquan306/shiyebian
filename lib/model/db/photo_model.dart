import 'dart:io';

import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/model/db/db_model.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';
import 'package:site_blackboard_app/utility/application_profile.dart';

class PhotoModel extends DbModel {
  @override
  String get tableName => 'photo';

  Future<List<PhotoItem>> findAll() async {
    var res = await (await db).query(tableName);
    List<PhotoItem> list =
        res.isNotEmpty ? res.map((c) => PhotoItem(map: c)).toList() : [];
    return list;
  }

  Future<List<PhotoItem>> findAllOrder(
      bool sortName, bool sortController, int constructionTypeId) async {
    var res = List<dynamic>();
    if (sortName) {
      var collateValue = ApplicationProfile.isIos ? '' : 'COLLATE UNICODE';
      if (sortController) {
        res = await (await db).query(tableName,
            where: '${PhotoColumn.constructionTypeId} = ?',
            whereArgs: [constructionTypeId],
            orderBy: '${PhotoColumn.name} $collateValue desc');
      } else {
        res = await (await db).query(tableName,
            where: '${PhotoColumn.constructionTypeId} = ?',
            whereArgs: [constructionTypeId],
            orderBy: '${PhotoColumn.name} $collateValue asc');
      }
    } else {
      if (sortController) {
        res = await (await db).query(tableName,
            where: '${PhotoColumn.constructionTypeId} = ?',
            whereArgs: [constructionTypeId],
            orderBy: '${PhotoColumn.updatedTime}   desc');
      } else {
        res = await (await db).query(tableName,
            where: '${PhotoColumn.constructionTypeId} = ?',
            whereArgs: [constructionTypeId],
            orderBy: '${PhotoColumn.updatedTime}   asc');
      }
    }

    List<PhotoItem> list =
        res.isNotEmpty ? res.map((c) => PhotoItem(map: c)).toList() : [];
    return list;
  }

  Future<List<PhotoItem>> findByConstructionTypeId(
      int constructionTypeId) async {
    var res = await (await db).query(tableName,
        where: '${PhotoColumn.constructionTypeId} = ?',
        whereArgs: [constructionTypeId],
        orderBy: '${PhotoColumn.name} desc');
    List<PhotoItem> list =
        res.isNotEmpty ? res.map((c) => PhotoItem(map: c)).toList() : [];
    return list;
  }

  Future<PhotoItem> get(int id) async {
    List<Map> maps = await (await db)
        .query(tableName, where: '${PhotoColumn.id} = ?', whereArgs: [id]);
    if (maps.length > 0) {
      return PhotoItem(map: maps.first);
    }

    return null;
  }

  Future<PhotoItem> insert(PhotoItem item) async {
    item.createdTime = DateTime.now().millisecondsSinceEpoch;
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    item.deletedTime = 0;
    item.id = await (await db).insert(tableName, item.toMap());
    return item;
  }

  update(PhotoItem item) async {
    item.updatedTime = DateTime.now().millisecondsSinceEpoch;
    await (await db).update(tableName, item.toMap(),
        where: '${PhotoColumn.id} = ?', whereArgs: [item.id]);
  }

  delete(int id) async {
    await (await db)
        .delete(tableName, where: '${PhotoColumn.id} = ?', whereArgs: [id]);
  }

  Future<bool> getNumByName(String name) async {
    List<Map> maps = await (await db)
        .query(tableName, where: '${PhotoColumn.name} = ? ', whereArgs: [name]);
    if (maps.length > 0) return false;
    return true;
  }

  deleteByConstructionTypeId(int constructionTypeId) async {
    List<PhotoItem> photoList =
        await findByConstructionTypeId(constructionTypeId);
    String photoPath = await App.photoPath;
    photoList.forEach((element) {
      File(photoPath + "/" + element.name).delete();
    });
    await (await db).delete(tableName,
        where: '${PhotoColumn.constructionTypeId} = ?',
        whereArgs: [constructionTypeId]);
  }
}
