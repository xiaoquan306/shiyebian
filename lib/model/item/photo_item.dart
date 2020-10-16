abstract class PhotoColumn {
  static final String id = 'id';
  static final String constructionTypeId = 'constructionTypeId';
  static final String name = 'name';
  static final String createdTime = 'createdTime';
  static final String updatedTime = 'updatedTime';
  static final String deletedTime = 'deletedTime';
}

class PhotoItem {
  int id;
  int constructionTypeId;
  String name;
  int createdTime;
  int updatedTime;
  int deletedTime;

  PhotoItem({Map<String, dynamic> map}) {
    if (null != map) {
      fromMap(map);
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      PhotoColumn.name: name,
      PhotoColumn.constructionTypeId: constructionTypeId,
      PhotoColumn.createdTime: createdTime,
      PhotoColumn.updatedTime: updatedTime,
      PhotoColumn.deletedTime: deletedTime
    };

    if (id != null) {
      map[PhotoColumn.id] = id;
    }

    return map;
  }

  Map toJson() {
    Map map = new Map();
    map["id"] = this.id;
    map["name"] = this.name;
    map["constructionTypeId"] = this.constructionTypeId;
    map["createdTime"] = this.createdTime;
    map["updatedTime"] = this.updatedTime;
    map["deletedTime"] = this.deletedTime;
    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map[PhotoColumn.id];
    name = map[PhotoColumn.name];
    constructionTypeId = map[PhotoColumn.constructionTypeId];
    createdTime = map[PhotoColumn.createdTime];
    updatedTime = map[PhotoColumn.updatedTime];
    deletedTime = map[PhotoColumn.deletedTime];
  }

  fromItem(PhotoItem item) {
    fromMap(item.toMap());
  }
}
