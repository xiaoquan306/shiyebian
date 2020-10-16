abstract class BlackboardColumn {
  static final String id = 'id';
  static final String caseId = 'caseId';
  static final String blackboardId = 'blackboardId';
  static final String contructor = 'contructor';
  static final String largeClassification = 'largeClassification';
  static final String photoClassification = 'photoClassification';
  static final String constructionType = 'constructionType';
  static final String middleClassification = 'middleClassification';
  static final String smallClassification = 'smallClassification';
  static final String title = 'title';
  static final String classificationRemarks1 = 'classificationRemarks1';
  static final String classificationRemarks2 = 'classificationRemarks2';
  static final String classificationRemarks3 = 'classificationRemarks3';
  static final String classificationRemarks4 = 'classificationRemarks4';
  static final String classificationRemarks5 = 'classificationRemarks5';
  static final String shootingSpot = 'shootingSpot';
  static final String isRepresentative = 'isRepresentative';
  static final String isFrequencyOfSubmission = 'isFrequencyOfSubmission';
  static final String contractorRemarks = 'contractorRemarks';
  static final String classification = 'classification';
  static final String name = 'name';
  static final String mark = 'mark';
  static final String designedValue = 'designedValue';
  static final String measuredValue = 'measuredValue';
  static final String unitName = 'unitName';
  static final String remarks1 = 'remarks1';
  static final String remarks2 = 'remarks2';
  static final String remarks3 = 'remarks3';
  static final String remarks4 = 'remarks4';
  static final String remarks5 = 'remarks5';
  static final String createdTime = 'createdTime';
  static final String updatedTime = 'updatedTime';
  static final String deletedTime = 'deletedTime';
}

class BlackboardItem {
  int id;
  int caseId;
  int blackboardId;
  String contructor;
  String largeClassification;
  String photoClassification;
  String constructionType;
  String middleClassification;
  String smallClassification;
  String title;
  String classificationRemarks1;
  String classificationRemarks2;
  String classificationRemarks3;
  String classificationRemarks4;
  String classificationRemarks5;
  String shootingSpot;
  int isRepresentative;
  int isFrequencyOfSubmission;
  String contractorRemarks;
  String classification;
  String name;
  String mark;
  String designedValue;
  String measuredValue;
  String unitName;
  String remarks1;
  String remarks2;
  String remarks3;
  String remarks4;
  String remarks5;
  int createdTime;
  int updatedTime;
  int deletedTime;

  BlackboardItem({Map<String, dynamic> map}) {
    if (null != map) {
      fromMap(map);
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      BlackboardColumn.caseId: caseId,
      BlackboardColumn.blackboardId: blackboardId,
      BlackboardColumn.contructor: contructor,
      BlackboardColumn.largeClassification: largeClassification,
      BlackboardColumn.photoClassification: photoClassification,
      BlackboardColumn.constructionType: constructionType,
      BlackboardColumn.middleClassification: middleClassification,
      BlackboardColumn.smallClassification: smallClassification,
      BlackboardColumn.title: title,
      BlackboardColumn.classificationRemarks1: classificationRemarks1,
      BlackboardColumn.classificationRemarks2: classificationRemarks2,
      BlackboardColumn.classificationRemarks3: classificationRemarks3,
      BlackboardColumn.classificationRemarks4: classificationRemarks4,
      BlackboardColumn.classificationRemarks5: classificationRemarks5,
      BlackboardColumn.shootingSpot: shootingSpot,
      BlackboardColumn.isRepresentative: isRepresentative,
      BlackboardColumn.isFrequencyOfSubmission: isFrequencyOfSubmission,
      BlackboardColumn.contractorRemarks: contractorRemarks,
      BlackboardColumn.classification: classification,
      BlackboardColumn.name: name,
      BlackboardColumn.mark: mark,
      BlackboardColumn.designedValue: designedValue,
      BlackboardColumn.measuredValue: measuredValue,
      BlackboardColumn.unitName: unitName,
      BlackboardColumn.remarks1: remarks1,
      BlackboardColumn.remarks2: remarks2,
      BlackboardColumn.remarks3: remarks3,
      BlackboardColumn.remarks4: remarks4,
      BlackboardColumn.remarks5: remarks5,
      BlackboardColumn.createdTime: createdTime,
      BlackboardColumn.updatedTime: updatedTime,
      BlackboardColumn.deletedTime: deletedTime
    };

    if (id != null) {
      map[BlackboardColumn.id] = id;
    }

    return map;
  }

  fromMap(Map<String, dynamic> map) {
    id = map[BlackboardColumn.id];
    caseId = map[BlackboardColumn.caseId];
    blackboardId = map[BlackboardColumn.blackboardId];
    contructor = map[BlackboardColumn.contructor];
    largeClassification = map[BlackboardColumn.largeClassification];
    photoClassification = map[BlackboardColumn.photoClassification];
    constructionType = map[BlackboardColumn.constructionType];
    middleClassification = map[BlackboardColumn.middleClassification];
    smallClassification = map[BlackboardColumn.smallClassification];
    title = map[BlackboardColumn.title];
    classificationRemarks1 = map[BlackboardColumn.classificationRemarks1];
    classificationRemarks2 = map[BlackboardColumn.classificationRemarks2];
    classificationRemarks3 = map[BlackboardColumn.classificationRemarks3];
    classificationRemarks4 = map[BlackboardColumn.classificationRemarks4];
    classificationRemarks5 = map[BlackboardColumn.classificationRemarks5];
    shootingSpot = map[BlackboardColumn.shootingSpot];
    isRepresentative = map[BlackboardColumn.isRepresentative];
    isFrequencyOfSubmission = map[BlackboardColumn.isFrequencyOfSubmission];
    contractorRemarks = map[BlackboardColumn.contractorRemarks];
    classification = map[BlackboardColumn.classification];
    name = map[BlackboardColumn.name];
    mark = map[BlackboardColumn.mark];
    designedValue = map[BlackboardColumn.designedValue];
    measuredValue = map[BlackboardColumn.measuredValue];
    unitName = map[BlackboardColumn.unitName];
    remarks1 = map[BlackboardColumn.remarks1];
    remarks2 = map[BlackboardColumn.remarks2];
    remarks3 = map[BlackboardColumn.remarks3];
    remarks4 = map[BlackboardColumn.remarks4];
    remarks5 = map[BlackboardColumn.remarks5];
    createdTime = map[BlackboardColumn.createdTime];
    updatedTime = map[BlackboardColumn.updatedTime];
    deletedTime = map[BlackboardColumn.deletedTime];
  }

  fromItem(BlackboardItem item) {
    fromMap(item.toMap());
  }
}
