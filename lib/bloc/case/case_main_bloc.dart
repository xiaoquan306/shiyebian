import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';

class CaseMainBloc extends BlocBase {
  BehaviorSubject<CaseItem> _item = BehaviorSubject<CaseItem>();
  Stream<CaseItem> get itemStream => _item.stream;
  @override
  void dispose() {
    _item.close();
  }

  getById(int id) async {
    _item.sink.add(await CaseModel().get(id));
  }
}
