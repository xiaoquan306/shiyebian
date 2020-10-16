import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/blackboard_model.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';

class BlackboardEditorBloc extends BlocBase {
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
    callLog('BlackboardEditorBloc.dispose');

    _getCaseById.close();
    _getBlackboardById.close();
  }

  getCaseById(int id) async {
    callLog('BlackboardEditorBloc.getCaseById: $id');

    _getCaseByIdSink.add(await CaseModel().get(id));
  }

  getBlackboardById(int id, int caseId, int templateId) async {
    callLog('BlackboardEditorBloc.getByBlackboardId: $id');

    if (id != null) {
      _getBlackboardByIdSink.add(await BlackboardModel().get(id));
    } else {
      BlackboardItem item = BlackboardItem();
      item.caseId = caseId;
      item.blackboardId = templateId;
      _getBlackboardByIdSink.add(item);
    }
  }

  create(BlackboardItem item) async {
    await BlackboardModel().insert(item);

    ///現在の新しい黒板をデフォルトで選択します
    CaseItem caseItem = await CaseModel().get(item.caseId);
    caseItem.blackboardDefault = item.id;
    await CaseModel().update(caseItem);
  }

  update(BlackboardItem item) async {
    await BlackboardModel().update(item);
  }
}
