import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/db/construction_type_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';

class ConstructionTypeBloc extends BlocBase {
  BehaviorSubject<CaseItem> _getCaseById = BehaviorSubject<CaseItem>();
  Sink<CaseItem> get _getCaseByIdSink => _getCaseById.sink;
  Stream<CaseItem> get getCaseByIdStream => _getCaseById.stream;

  BehaviorSubject<List<ConstructionTypeItem>> _fetchAll =
      BehaviorSubject<List<ConstructionTypeItem>>();
  Sink<List<ConstructionTypeItem>> get _fetchAllSink => _fetchAll.sink;
  Stream<List<ConstructionTypeItem>> get fetchAllStream => _fetchAll.stream;

  @override
  void dispose() {
    callLog('ConstructionTypeBloc.dispose');
    _fetchAll.close();
    _getCaseById.close();
  }

  ///ケース情報を取得する
  getCaseById(int id) async {
    callLog('ConstructionTypeBloc.getCaseById: $id');
    _getCaseByIdSink.add(await CaseModel().get(id));
  }

  ///ケースIDに基づいて作業タイプのリストを取得する
  fetchAll(int caseId) async {
    callLog('ConstructionTypeBloc.fetchAll: $caseId');
    _fetchAllSink.add(await ConstructionTypeModel().findByCaseId(caseId));
  }

  ///ジョブタイプを削除
  delete(ConstructionTypeItem item) async {
    callLog('ConstructionTypeBloc.delete: ${item.toMap()}');
    assert(item != null);
    await ConstructionTypeModel().delete(item);
  }

  ///ジョブの並べ替え
  constructionTypeOrder(bool isSortByName, int caseId, bool order) async {
    _fetchAllSink.add(await ConstructionTypeModel()
        .findByCaseIdOrder(isSortByName, caseId, order));
  }
}
