import 'package:site_blackboard_app/bloc/bloc_base.dart';
import 'package:site_blackboard_app/config/lang_define.dart';
import 'package:site_blackboard_app/model/db/case_model.dart';
import 'package:site_blackboard_app/model/db/construction_type_model.dart';
import 'package:site_blackboard_app/model/item/case_item.dart';
import 'package:site_blackboard_app/model/item/construction_type_item.dart';

class CaseCreateBloc extends BlocBase {
  @override
  void dispose() {}
  create(CaseItem item, context) async {
    bool sameName = await CaseModel().getCaseName(item.name);
    if (sameName == false) {
      return sameName;
    } else {
      item = await CaseModel().insert(item);
      //プロジェクトディレクトリを作成
      int defId = await ConstructionTypeModel().getIdByDefault(item.id);
      if (defId == null) {
        ConstructionTypeItem folderItem = new ConstructionTypeItem();
        folderItem.caseId = item.id;
        folderItem.name = LangGlobal.other;
        folderItem.isDefault = 1;
        await ConstructionTypeModel().insert(folderItem);
      }
    }
  }
}
