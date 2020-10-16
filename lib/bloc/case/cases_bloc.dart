import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';

class CasesBloc extends BlocBase {
  BehaviorSubject<List<CaseItem>> _fetchAll = BehaviorSubject<List<CaseItem>>();
  Sink<List<CaseItem>> get _fetchAllSink => _fetchAll.sink;
  Stream<List<CaseItem>> get fetchAllStream => _fetchAll.stream;

  // BehaviorSubject<CaseItem> _getByActive = BehaviorSubject<CaseItem>();
  // Sink<CaseItem> get _getByActiveSink => _getByActive.sink;
  // Stream<CaseItem> get getByActiveStream => _getByActive.stream;

  @override
  void dispose() {
    callLog('CasesBloc.dispose');
    _fetchAll.close();
    // _getByActive.close();
  }

  fetchAll() async {
    callLog('CasesBloc.fetchAll');
    _fetchAllSink.add(await CaseModel().findAll());
  }

  delete(CaseItem item) async {
    callLog('CasesBloc.delete: ${item.toMap()}');

    assert(item != null);
    await CaseModel().delete(item.id);
  }

  // getByActive() async {
  //   callLog('CasesBloc.getByActive');
  //
  //   _getByActiveSink.add(await CaseModel().getByActive());
  // }
}
