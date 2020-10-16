import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/blackboard_model.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';

class BlackboardsBloc extends BlocBase {
  BehaviorSubject<CaseItem> _getCaseById = BehaviorSubject<CaseItem>();
  Sink<CaseItem> get _getCaseByIdSink => _getCaseById.sink;
  Stream<CaseItem> get getCaseByIdStream => _getCaseById.stream;

  BehaviorSubject<List<BlackboardItem>> _fetchByCaseId =
      BehaviorSubject<List<BlackboardItem>>();
  Sink<List<BlackboardItem>> get _fetchByCaseIdSink => _fetchByCaseId.sink;
  Stream<List<BlackboardItem>> get fetchByCaseIdStream => _fetchByCaseId.stream;

  @override
  void dispose() {
    callLog('BlackboardsBloc.dispose');

    _getCaseById.close();
    _fetchByCaseId.close();
  }

  getCaseById(int id) async {
    callLog('BlackboardsBloc.getCase: $id');

    _getCaseByIdSink.add(await CaseModel().get(id));
  }

  fetchByCaseId(int caseId) async {
    callLog('BlackboardsBloc.fetchByCaseId: $caseId');

    _fetchByCaseIdSink.add(await BlackboardModel().findByCaseId(caseId));
  }

  delete(BlackboardItem item) async {
    await BlackboardModel().delete(item.id);

    ///黒板を削除すると、デフォルトの黒板と設定状態が自動的に更新されます
    CaseItem caseItem = await CaseModel().get(item.caseId);
    if (caseItem.blackboardDefault == item.id) {
      BlackboardItem blockBoardItem =
          await BlackboardModel().getNextByCaseId(item.caseId);
      if (blockBoardItem != null) {
        caseItem.blackboardDefault = blockBoardItem.id;
      } else {
        caseItem.blackboardDefault = null;
        caseItem.useBlackboard = 0;
        // caseItem.saveOriginal = 0;
      }
      await CaseModel().update(caseItem);
    }

//    await fetchByCaseId(item.caseId);
  }

  changeDefaultBlackboard(
      {@required CaseItem caseItem,
      @required BlackboardItem blackboardItem}) async {
    caseItem.blackboardDefault = blackboardItem.id;
    await CaseModel().update(caseItem);
  }
}
