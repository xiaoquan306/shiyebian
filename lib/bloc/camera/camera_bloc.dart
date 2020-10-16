import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/blackboard_model.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/db/construction_type_model.dart';
import 'package:site_blackboard_app/model/db/photo_model.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';

class CameraBloc extends BlocBase {
  BehaviorSubject<CaseItem> _getCaseById = BehaviorSubject<CaseItem>();
  Sink<CaseItem> get _getCaseByIdSink => _getCaseById.sink;
  Stream<CaseItem> get getCaseByIdStream => _getCaseById.stream;

  BehaviorSubject<BlackboardItem> _getBlackboardById =
      BehaviorSubject<BlackboardItem>();
  Sink<BlackboardItem> get _getBlackboardByIdSink => _getBlackboardById.sink;
  Stream<BlackboardItem> get getBlackboardByIdStream =>
      _getBlackboardById.stream;

  @override
  void dispose() {
    callLog('CameraBloc.dispose');

    _getCaseById.close();
    _getBlackboardById.close();
  }

  getCaseById(int caseId) async {
    callLog('CameraBloc.getCaseById: $caseId');

    _getCaseByIdSink.add(await CaseModel().get(caseId));
  }

  getBlackboardById(int blackboardId) async {
    callLog('CameraBloc.getBlackboardById: $blackboardId');

    _getBlackboardByIdSink.add(await BlackboardModel().get(blackboardId));
  }

  Future<ConstructionTypeItem> _getConstructionType(
      int caseId, String constructionType) async {
    ConstructionTypeItem item;

    item = await ConstructionTypeModel().getByName(caseId, constructionType);
    if (item == null) {
      item = ConstructionTypeItem(
          map: {'name': constructionType, 'caseId': caseId, 'isDefault': 0});
      item = await ConstructionTypeModel().insert(item);
    }

    return item;
  }

  savePhoto(int id, String constructionType, String fileName) async {
    ConstructionTypeItem constructionTypeItem =
        await _getConstructionType(id, constructionType);

    PhotoItem photoItem = new PhotoItem();
    photoItem.constructionTypeId = constructionTypeItem.id;
    photoItem.name = fileName;
    photoItem.createdTime = DateTime.now().millisecondsSinceEpoch;
    photoItem.updatedTime = DateTime.now().millisecondsSinceEpoch;
    await PhotoModel().insert(photoItem);
  }
}
