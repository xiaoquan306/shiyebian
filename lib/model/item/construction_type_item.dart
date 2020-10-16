abstract class ConstructionTypeColumn {
  static final String id = 'id';
  static final String name = 'name';
  static final String caseId = 'caseId';
  static final String isDefault = 'isDefault';
  static final String createdTime = 'createdTime';
  static final String updatedTime = 'updatedTime';
  static final String deletedTime = 'deletedTime';
  static final String photoCount = 'photoCount';
}

class ConstructionTypeItem {
  int id;
  String name;
  int caseId;
  int isDefault;
  int createdTime;
  int updatedTime;
  int deletedTime;
  int photoCount;

  ConstructionTypeItem({Map<String, dynamic> map}) {
    if (null != map) {
      fromMap(map);
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      ConstructionTypeColumn.name: name,
      ConstructionTypeColumn.caseId: caseId,
      ConstructionTypeColumn.isDefault: isDefault,
      ConstructionTypeColumn.createdTime: createdTime,
      ConstructionTypeColumn.updatedTime: updatedTime,
      ConstructionTypeColumn.deletedTime: deletedTime,
      ConstructionTypeColumn.photoCount: photoCount
    };

    if (id != null) {
      map[ConstructionTypeColumn.id] = id;
    }

    return map;
  }

  Map<String, dynamic> toMapByDb() {
    var map = <String, dynamic>{
      ConstructionTypeColumn.name: name,
      ConstructionTypeColumn.caseId: caseId,
      ConstructionTypeColumn.isDefault: isDefault,
      ConstructionTypeColumn.createdTime: createdTime,
      ConstructionTypeColumn.updatedTime: updatedTime,
      ConstructionTypeColumn.deletedTime: deletedTime,
    };

    if (id != null) {
      map[ConstructionTypeColumn.id] = id;
    }

    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map[ConstructionTypeColumn.id];
    name = map[ConstructionTypeColumn.name];
    caseId = map[ConstructionTypeColumn.caseId];
    isDefault = map[ConstructionTypeColumn.isDefault];
    createdTime = map[ConstructionTypeColumn.createdTime];
    updatedTime = map[ConstructionTypeColumn.updatedTime];
    deletedTime = map[ConstructionTypeColumn.deletedTime];
    photoCount = map[ConstructionTypeColumn.photoCount];
  }

  fromItem(ConstructionTypeItem item) {
    fromMap(item.toMap());
  }
}
