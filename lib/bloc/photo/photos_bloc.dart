import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:site_blackboard_app/app/app.dart';
import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/db/photo_model.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';
import 'package:toast/toast.dart';

class PhotosBloc extends BlocBase {
  BehaviorSubject<List<PhotoItem>> _fetchAll =
      BehaviorSubject<List<PhotoItem>>();
  Sink<List<PhotoItem>> get _fetchAllSink => _fetchAll.sink;
  Stream<List<PhotoItem>> get fetchAllStream => _fetchAll.stream;

  @override
  void dispose() {
    callLog('PhotosBloc.dispose');
    _fetchAll.close();
  }

  fetchAll(int constructionTypeId) async {
    _fetchAllSink
        .add(await PhotoModel().findByConstructionTypeId(constructionTypeId));
  }

  Future<List<PhotoItem>> photoOrder(
      bool name, int constructionTypeId, bool order) async {
    List<PhotoItem> photoList =
        await PhotoModel().findAllOrder(name, order, constructionTypeId);
    _fetchAll.add(photoList);
    return photoList;
  }

  update(PhotoItem item, String newName, BuildContext context) async {
    bool controller = await PhotoModel().getNumByName(newName);
    if (controller) {
      File file = new File((await App.photoPath) + "/" + item.name);
      file.rename((await App.photoPath) + "/" + newName);
      item.name = newName;
      await PhotoModel().update(item);
    } else {
      Toast.show(LangPhotos.samePhotoName, context, duration: 2);
    }
  }

  delete(PhotoItem item) async {
    callLog('PhotosBloc.delete: ${item.toMap()}');

    assert(item != null);
    await PhotoModel().delete(item.id);
  }
}
