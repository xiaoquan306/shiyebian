import 'package:rxdart/subjects.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/model/db/photo_model.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';

class PhotoPreviewBloc extends BlocBase {
  BehaviorSubject<PhotoItem> _photoItem = BehaviorSubject<PhotoItem>();
  Sink<PhotoItem> get photoItemSink => _photoItem.sink;
  Stream<PhotoItem> get photoItemStream => _photoItem.stream;

  @override
  void dispose() {
    _photoItem.close();
  }

  findPhotoById(int id) async {
    callLog('PhotoItem.findPhotoById');
    _photoItem.add(await PhotoModel().get(id));
  }

  delete(PhotoItem item) async {
    callLog('PhotosBloc.delete: ${item.toMap()}');

    assert(item != null);
    await PhotoModel().delete(item.id);
  }
}
