abstract class CaseColumn {
  static final String id = 'id';
  static final String name = 'name';
  static final String constructionName = 'constructionName';
  static final String preview = 'preview';
  static final String savePosition = 'savePosition';
  static final String useBlackboard = 'useBlackboard';
  static final String saveOriginal = 'saveOriginal';
  static final String tamperProof = 'tamperProof';
  static final String blackboardDefault = 'blackboardDefault';
  static final String activated = 'activated';
  static final String createdTime = 'createdTime';
  static final String updatedTime = 'updatedTime';
  static final String deletedTime = 'deletedTime';
}

class CaseItem {
  int id;
  String name;
  String constructionName = "";
  String preview;
  int savePosition;
  int useBlackboard;
  int saveOriginal;
  int tamperProof;
  int blackboardDefault;
  int createdTime;
  int updatedTime;
  int deletedTime;
  int activated = 0;

  CaseItem({Map<String, dynamic> map}) {
    if (null != map) {
      fromMap(map);
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      CaseColumn.name: name,
      CaseColumn.constructionName: constructionName,
      CaseColumn.preview: preview,
      CaseColumn.savePosition: savePosition,
      CaseColumn.useBlackboard: useBlackboard,
      CaseColumn.saveOriginal: saveOriginal,
      CaseColumn.tamperProof: tamperProof,
      CaseColumn.blackboardDefault: blackboardDefault,
      CaseColumn.activated: activated,
      CaseColumn.createdTime: createdTime,
      CaseColumn.updatedTime: updatedTime,
      CaseColumn.deletedTime: deletedTime
    };

    if (id != null) {
      map[CaseColumn.id] = id;
    }

    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map[CaseColumn.id];
    name = map[CaseColumn.name];
    constructionName = map[CaseColumn.constructionName];
    preview = map[CaseColumn.preview];
    savePosition = map[CaseColumn.savePosition];
    useBlackboard = map[CaseColumn.useBlackboard];
    useBlackboard = map[CaseColumn.useBlackboard];
    saveOriginal = map[CaseColumn.saveOriginal];
    tamperProof = map[CaseColumn.tamperProof];
    blackboardDefault = map[CaseColumn.blackboardDefault];
    activated = map[CaseColumn.activated];
    createdTime = map[CaseColumn.createdTime];
    updatedTime = map[CaseColumn.updatedTime];
    deletedTime = map[CaseColumn.deletedTime];
  }

  fromItem(CaseItem item) {
    fromMap(item.toMap());
  }
}
