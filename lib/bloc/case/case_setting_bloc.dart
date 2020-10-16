import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';

class CaseSettingBloc extends BlocBase {
  BehaviorSubject<CaseItem> _getCaseById = BehaviorSubject<CaseItem>();
  Sink<CaseItem> get _getCaseByIdSink => _getCaseById.sink;
  Stream<CaseItem> get getCaseByIdStream => _getCaseById.stream;

  @override
  void dispose() {
    _getCaseById.close();
  }

  getById(int id) async {
    callLog('CaseSettingBloc.getById: $id');
    _getCaseByIdSink.add(await CaseModel().get(id));
  }

  update(CaseItem item) async {
    callLog('CaseSettingBloc.update: $item');
    await CaseModel().updateSetting(item);
    getById(item.id);
  }
}
