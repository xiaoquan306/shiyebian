import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';

class BlackboardsDrawerBloc extends BlocBase {
  BehaviorSubject<List<CaseItem>> _fetchByName =
      BehaviorSubject<List<CaseItem>>();
  Sink<List<CaseItem>> get _fetchByNameSink => _fetchByName.sink;
  Stream<List<CaseItem>> get fetchByNameStream => _fetchByName.stream;

  @override
  void dispose() {
    callLog('BlackboardsDrawerBloc.dispose');
    _fetchByName.close();
  }

  fetchByName(String caseName) async {
    callLog('BlackboardsDrawerBloc.fetchByName: $caseName');

    _fetchByNameSink.add(await CaseModel().findByName(caseName));
  }
}
