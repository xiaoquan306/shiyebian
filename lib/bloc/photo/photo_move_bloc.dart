import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/db/construction_type_model.dart';
import 'package:site_blackboard_app/model/db/photo_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';

class PhotoMoveBloc extends BlocBase {
  BehaviorSubject<List<CaseItem>> _fetchCaseItem =
      BehaviorSubject<List<CaseItem>>();
  Sink<List<CaseItem>> get _caseItemSink => _fetchCaseItem.sink;
  Stream<List<CaseItem>> get caseItemListStream => _fetchCaseItem.stream;

  BehaviorSubject<List<ConstructionTypeItem>> _fetchConstructionTypeItem =
      BehaviorSubject<List<ConstructionTypeItem>>();
  Sink<List<ConstructionTypeItem>> get _fetchAllConstructionTypeItemSink =>
      _fetchConstructionTypeItem.sink;
  Stream<List<ConstructionTypeItem>> get constructionTypeItemListStream =>
      _fetchConstructionTypeItem.stream;

  BehaviorSubject<PhotoItem> _getPhotoItem = BehaviorSubject<PhotoItem>();
  Sink<PhotoItem> get _photoItemSink => _getPhotoItem.sink;
  Stream<PhotoItem> get photoItemStream => _getPhotoItem.stream;

  @override
  void dispose() {
    _fetchCaseItem.close();
    _fetchConstructionTypeItem.close();
    _getPhotoItem.close();
  }

  fetchCasesItem() async {
    callLog('CasesBloc.fetchAll');
    _caseItemSink.add(await CaseModel().findAll());
  }

  fetchConstructionTypeItem() async {
    callLog('ConstructionTypeItem.fetchAll');
    _fetchAllConstructionTypeItemSink
        .add(await ConstructionTypeModel().findAll());
  }

  getPhotoItemById(int id) async {
    callLog('PhotoIte.get');
    _photoItemSink.add(await PhotoModel().get(id));
  }

  updatePhotoItem(PhotoItem item) async {
    await PhotoModel().update(item);
  }
}
