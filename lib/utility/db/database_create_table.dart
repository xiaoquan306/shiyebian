import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCreateTable {
  static void createCases(Batch batch) {
    batch.execute('''create table cases (
      id integer primary key AUTOINCREMENT,
      name text not null,
      constructionName text not null,
      preview text null,
      savePosition integer DEFAULT 0,
      useBlackboard integer DEFAULT 1,
      saveOriginal integer DEFAULT 0,
      tamperProof integer DEFAULT 1,
      activated integer DEFAULT 0,
      blackboardDefault int null,
      createdTime integer null,
      updatedTime integer null,
      deletedTime integer DEFAULT 0)
      ''');
  }

  static void createBlackboard(Batch batch) {
    batch.execute('''create table blackboard (
      id integer primary key AUTOINCREMENT,
      caseId integer not null,
      blackboardId integer not null,
      contructor text null,
      largeClassification text null,
      photoClassification text null,
      constructionType text null,
      middleClassification text null,
      smallClassification text null,
      title text null,
      classificationRemarks1 text null,
      classificationRemarks2 text null,
      classificationRemarks3 text null,
      classificationRemarks4 text null,
      classificationRemarks5 text null,
      shootingSpot text null,
      isRepresentative integer DEFAULT 0,
      isFrequencyOfSubmission integer DEFAULT 0,
      contractorRemarks text null,
      classification text null,
      name text null,
      mark text null,
      designedValue text null,
      measuredValue text null,
      unitName text null,
      remarks1 text null,
      remarks2 text null,
      remarks3 text null,
      remarks4 text null,
      remarks5 text null,
      createdTime integer null,
      updatedTime integer null,
      deletedTime integer DEFAULT 0,
      CONSTRAINT "案件ID" FOREIGN KEY ("caseId") REFERENCES "cases" ("id") ON DELETE CASCADE ON UPDATE CASCADE)
      ''');
  }

  static void createConstructionType(Batch batch) {
    batch.execute('''create table constructionType (
      id integer primary key AUTOINCREMENT,
      caseId integer not null,
      name text not null,
      isDefault integer DEFAULT 0,
      createdTime integer null,
      updatedTime integer null,
      deletedTime integer DEFAULT 0,
      CONSTRAINT "案件ID" FOREIGN KEY ("caseId") REFERENCES "cases" ("id") ON DELETE CASCADE ON UPDATE CASCADE)
      ''');
  }

  static void createPhoto(Batch batch) {
    batch.execute('''create table photo(
      id integer primary key AUTOINCREMENT,
      constructionTypeId integer null,
      name text not null,
      northLatitude num null,
      southLatitude num null,
      eastLongitude num null,
      westLongitude num null,
      createdTime integer null,
      updatedTime integer null,
      deletedTime integer DEFAULT 0,
      CONSTRAINT "工種ID" FOREIGN KEY ("constructionTypeId") REFERENCES "constructionType" ("id") ON DELETE CASCADE ON UPDATE CASCADE)
      ''');
  }

  static void initCase(Batch batch) {
    batch.execute(
        '''INSERT INTO cases(name,activated,constructionName,blackboardDefault,createdTime,updatedTime) 
    VALUES("${LangCases.defaultName}", 1,"${LangCases.defaultConstructionSubject}",1,${DateTime.now().millisecondsSinceEpoch},${DateTime.now().millisecondsSinceEpoch})''');
  }

  static void initBlackboard(Batch batch) {
    batch.execute(
        '''INSERT INTO blackboard(caseId,blackboardId,createdTime,updatedTime) 
    VALUES(1,1,${DateTime.now().millisecondsSinceEpoch},${DateTime.now().millisecondsSinceEpoch})''');
  }

  static void initConstructionType(Batch batch) {
    batch.execute(
        '''INSERT INTO constructionType(name,caseId,isDefault,createdTime,updatedTime) 
    VALUES("${LangGlobal.other}",1,1,${DateTime.now().millisecondsSinceEpoch},${DateTime.now().millisecondsSinceEpoch})''');
  }

// static void createCasesV1(Batch batch) {
//   batch.execute('''create table cases (
//     id integer primary key,
//     name text not null,
//     constructionName text not null,
//     preview text null,
//     savePosition integer DEFAULT 1,
//     useBlackboard integer DEFAULT 1,
//     saveOriginal integer DEFAULT 1,
//     tamperProof integer DEFAULT 1,
//     blackboardDefault int null,
//     createdTime integer null,
//     updatedTime integer null,
//     deletedTime integer DEFAULT 0)
//     ''');
// }

// static void createBlackboardV1(Batch batch) {
//   batch.execute('''create table blackboard (
//     id integer primary key,
//     caseId integer not null,
//     blackboardId integer not null,
//     contructor text null,
//     largeClassification text null,
//     photoClassification text null,
//     constructionTypeId integer null,
//     constructionType text null,
//     middleClassification text null,
//     smallClassification text null,
//     title text null,
//     classificationRemarks text null,
//     shootingSpot text null,
//     isRepresentative integer DEFAULT 0,
//     isFrequencyOfSubmission integer DEFAULT 0,
//     measurements text null,
//     contractorRemarks text null,
//     classification text null,
//     measurementItems text null,
//     name text null,
//     mark text null,
//     designedValue text null,
//     measuredValue text null,
//     unitName text null,
//     remarks text null,
//     createdTime integer null,
//     updatedTime integer null,
//     deletedTime integer DEFAULT 0)
//     ''');
// }

// static void createPhotoV1(Batch batch) {
//   batch.execute('''create table photo(
//     id integer primary key,
//     constructionTypeId integer null,
//     name text not null,
//     localPath text not null,
//     createdTime integer null,
//     updatedTime integer null,
//     deletedTime integer DEFAULT 0)
//     ''');
// }

}
