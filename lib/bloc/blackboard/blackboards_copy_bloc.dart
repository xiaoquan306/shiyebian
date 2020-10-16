import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/blackboard_model.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';

class BlackboardsCopyBloc extends BlocBase {
  BehaviorSubject<CaseItem> _getCaseById = BehaviorSubject<CaseItem>();
  Sink<CaseItem> get _getCaseByIdSink => _getCaseById.sink;
  Stream<CaseItem> get getCaseByIdStream => _getCaseById.stream;

  BehaviorSubject<List<BlackboardItem>> _fetchByCaseId =
      BehaviorSubject<List<BlackboardItem>>();
  Sink<List<BlackboardItem>> get _fetchByCaseIdSink => _fetchByCaseId.sink;
  Stream<List<BlackboardItem>> get fetchByCaseIdStream => _fetchByCaseId.stream;

  @override
  void dispose() {
    _getCaseById.close();
    _fetchByCaseId.close();
  }

  getCaseById(int id) async {
    _getCaseByIdSink.add(await CaseModel().get(id));
  }

  fetchByCaseId(int caseId) async {
    _fetchByCaseIdSink.add(await BlackboardModel().findByCaseId(caseId));
  }

  copy(int fromBlackBoardId, int copyToCaseId) async {
    BlackboardItem fromItem = await BlackboardModel().get(fromBlackBoardId);
    Map<String, dynamic> fromItemMap = fromItem.toMap();
    fromItemMap[BlackboardColumn.id] = null;
    fromItemMap[BlackboardColumn.caseId] = copyToCaseId;
    BlackboardItem newItem = BlackboardItem(map: fromItemMap);
    await BlackboardModel().insert(newItem);

    CaseItem caseItem = await CaseModel().get(copyToCaseId);
    caseItem.blackboardDefault = newItem.id;
    await CaseModel().update(caseItem);
  }

  copyMultiple(List selectedIdsToCase, int copyToCaseId) async {
    selectedIdsToCase.forEach((ids) async {
      BlackboardItem fromItem = await BlackboardModel().get(ids);
      Map<String, dynamic> fromItemMap = fromItem.toMap();
      fromItemMap[BlackboardColumn.id] = null;
      fromItemMap[BlackboardColumn.caseId] = copyToCaseId;
      BlackboardItem newItem = BlackboardItem(map: fromItemMap);
      await BlackboardModel().insert(newItem);
      CaseItem caseItem = await CaseModel().get(copyToCaseId);
      caseItem.blackboardDefault = newItem.id;
      await CaseModel().update(caseItem);
    });
  }
}
