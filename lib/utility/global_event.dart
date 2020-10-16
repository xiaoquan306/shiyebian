import 'package:event_bus/event_bus.dart';
import 'package:site_blackboard_app/model/item/blackboard_item.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/photo_item.dart';

EventBus globalEventBus = new EventBus();

class BlackboardChangeEvent {
  BlackboardChangeEvent(this.blackboardItem);
  BlackboardItem blackboardItem;
}

class TransBlackBoardEvent {
  BlackboardItem blockBoardItem;
  TransBlackBoardEvent(this.blockBoardItem);
}

class BlackBoardUpdateCaseEvent {
  CaseItem item;
  BlackBoardUpdateCaseEvent(this.item);
}

class TransPhotoEvent {
  PhotoItem photoItem;
  TransPhotoEvent(this.photoItem);
}
