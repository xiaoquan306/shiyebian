String lang(String text, Map<String, dynamic> params) {
  params.forEach((key, value) {
    text = text.replaceAll('{$key}', value.toString());
  });
  return text;
}

abstract class LangGlobal {
  static const String yes = 'はい';
  static const String no = 'いいえ';
  static const String ok = '確認';
  static const String back = '戻る';
  static const String other = 'その他';
  static const String cancel = 'キャンセル';
  static const String anErrorOccurred = 'エラーが発生しました';
  static const String editProfile = "プロフィール編集";
  static const String license = "ライセンス";
  static const String logout = "ログアウト";
}

abstract class LangCases {
  static const String createCase = "新規登録";
  static const String updateCase = "編集";
  static const String deleteCase = '削除';
  static const String caseBrowser = '案件一覧';
  static const String caseName = "案件名";
  static const String constructionSubject = "工事件名";
  static const String cameraHasBeenDisabled = "撮影が許可されません";
  static const String memoryIsDisabled = "端末上のファイルへのアクセスが許可されません";
  static const String setTheTemplateFirst = "レイアウトを選択してください.";
  static const String canDeleteSelectedCase = "本当に削除してよろしいですか？";
  static const String caseEditor = "案件情報編集";
  static const String create = "登録";
  static const String projectTitle = "案件名";
  static const String projectTitleNotice = "案件名を入力してください";
  static const String SubjectTitleNotice = "工事件名を入力してください";
  static const String sameCaseName = "同じ案件名が既に存在します";
  static const String returnCaseDetailsReminder = "前回開いていた案件を開きます";
  static const String defaultName = "サンプル案件";
  static const String defaultConstructionSubject = "サンプル工事";
}

abstract class LangCaseMain {
  static const String caseBrowser = '案件一覧';
  static const String shoot = '撮影';
  static const String albumBrowser = '写真一覧';
  static const String blackboard = '黒板一覧';
  static const String settings = '設定';
}

abstract class LangCamera {
  static const String settings = '設定';
  static const String loading = "読み込み中...";
  static const String shoot = '撮影';
  static const String savedSuccessfully = "保存に成功しました";
  static const String savedSuccessfullyButLocationCouldNotBeObtained =
      '保存しましたが、位置情報が取得できません';
  static const String originalFileSuffix = "黒板なし";
  static const String locationServiceIsNotTurnedOn =
      "あなたの場所情報を特定できません。デバイスの設定でモバイルネットワークとGPSサービスが有効になっていることを確認してください。";
  static const String requestLocationPermission = '位置情報サービスを許可してください';
  static const String requestCameraPermission = 'カメラ機能が認証されていません';
}

abstract class LangConstructionTypes {
  static const String sortByName = '名前';
  static const String sorting = '並べ替え';
  static const String sortByUpdated = '更新日時';
  static const String deleteFolder = '削除';
  static const String outputFolder = 'エクスポート';
  static const String deleteCase = 'ケースの削除';
  static const String canIDeleteTheSelectedFolder = '本当に削除してよろしいですか？';
  static const String canIOutputTheSelectedFolder = '本当に選択したデータをエクスポートしますか？';
  static const String constructionTypeExport = '工種のエクスポート';
  static const String canConstructionTypeExport = 'この工種をエクスポートしますか？';
}

abstract class LangPhotos {
  static const String sortByName = '名前';
  static const String sort = '並べ替え';
  static const String sortByUpdated = '更新日時';
  static const String rename = 'リネーム';
  static const String preview = 'プレビュー';
  static const String moveFolder = 'フォルダ移動';
  static const String delete = '削除';
  static const String deleteImage = '削除';
  static const String canDeleteImage = '本当に削除してよろしいですか？';
  static const String enterTheImageName = "画像名を入力してください";
  static const String moveFiles = "ファイルを移動する";
  static const String moveFilesNotice = "{txt1}を{txt2}に移動してよろしいですか？";
  static const String samePhotoName = '画像の名前が重複しています';
  static const String unableMove = 'ファイルは案件フォルダに移動できません。工種フォルダに移動してください。';
  static const String photoExport = '写真のエクスポート';
  static const String canExportPhoto = 'この写真をエクスポートしますか？';
  // static const String
}

abstract class LangPhotoPreview {
  static const String shingles = '写真削除';
  static const String confirmDelete = '本当に削除してよろしいですか？';
  static const String detailedInformation = '詳細';
  static const String fileInformation = '[ファイル情報]';
  static const String path = 'パス';
  static const String size = 'サイズ';
  static const String byte = 'バイト';
  static const String changeDate = '変更日';
  static const String numberOfPixels = '画素数';
  static const String locationInformation = '[位置情報]';
  static const String latitude = '緯度';
  static const String longitude = '経度';
  static const String blackboardInformation = '[黒板情報]';
  static const String majorClassification = '大分類';
  static const String photoClassification = '写真区分';
  static const String close = '閉じる';
  static const String millionPixels = '万画素';
}

abstract class LangBlackboards {
  static const String blackboardList = "黒板一覧";
  static const String addNew = "新規";
  static const String create = "登録";
  static const String bulk = "一括";
  static const String currentBlackboard = "これ以外の案件を選択してください";
  static const String copySuccessfully = "コピーしました";
  static const String useTheCopiedBlackboard = "選択した黒板をコピーする";
  static const String useTheSelectedBlackboard = "選択した黒板を利用する";
  static const String makeNewBlackboard = "新規黒板を作ってください";
  static const String selectABlackboard = "黒板を選択してください";
  static const String copyBlackboard = "コピーする黒板を選んでください";
  static const String noBlackboard = "黒板を選択してください";
  static const String caseName = "案件名";
  static const String update = "編集";
  static const String delete = '削除';
  static const String photography = '撮影';
  static const String copy = "コピーする";
  static const String search = "検索";
  static const String showAll = "すべて表示";
  static const String blackboardDeleted = "黒板削除";
  static const String blackboardCopy = "黒板コピー";
  static const String deletesTheSelectedBlackboard = "本当に削除してよろしいですか？";
  static const String copySelectedBlackboard = "案件の黒板をすべてコピーしますか？";
}

abstract class LangBlackboardEditor {
  static const String largeClassification = "写真-大分類";
  static const String photoClassification = '写真区分';
  static const String constructionType = "工種";
  static const String middleClassification = "種別";
  static const String smallClassification = "細別";
  static const String title = "写真タイトル";
  static const String classificationRemarks1 = "工種区分予備1";
  static const String classificationRemarks2 = "工種区分予備2";
  static const String classificationRemarks3 = "工種区分予備3";
  static const String classificationRemarks4 = "工種区分予備4";
  static const String classificationRemarks5 = "工種区分予備5";
  static const String shootingLocation = "撮影箇所";
  static const String isRepresentative = "代表写真";
  static const String isFrequencyOfSubmission = "提出頻度写真";
  static const String contractorRemarks = "受注者説明分";
  static const String classification = "測定分類";
  static const String measurementItems = "測定値";
  static const String name = "測定項目";
  static const String mark = "記号";
  static const String designedValue = "設計値";
  static const String measuredValue = "実測値";
  static const String unitName = "単位名称";
  static const String remarks1 = "施工管理地予備1";
  static const String remarks2 = "施工管理地予備2";
  static const String remarks3 = "施工管理地予備3";
  static const String remarks4 = "施工管理地予備4";
  static const String remarks5 = "施工管理地予備5";
  static const String constructionContent = "工事内容";
  static const String update = "編集";
  static const String create = "登録";
  static const String blackboardIdError = "黒板IDエラー";
  static const String contractor = "受注者";
  static const String largeClassification1 = "工事";
  static const String largeClassification2 = "測量";
  static const String largeClassification3 = "調査";
  static const String largeClassification4 = "地質";
  static const String largeClassification5 = "広報";
  static const String largeClassification6 = "設計";
  static const String largeClassification7 = "その他";
  static const String photoClassification1 = "着手前及び完成写真";
  static const String photoClassification2 = "施工状況写真";
  static const String photoClassification3 = "安全管理写真";
  static const String photoClassification4 = "使用材料写真";
  static const String photoClassification5 = "品質管理写真";
  static const String photoClassification6 = "出来形管理写真";
  static const String photoClassification7 = "災害写真";
  static const String photoClassification8 = "事故写真";
  static const String photoClassification9 = "その他";
  static const String nameItem0 = "施工管理値";
  static const String nameItem1 = "品質証明値";
  static const String nameItem2 = "監督値";
  static const String nameItem3 = "検査値";
  static const String nameItem9 = "その他";
}

abstract class LangBlackboardTemplates {
  static const String blackboardList = "黒板一覧";
  static const String layoutSelection = "レイアウト選択";
  static const String layoutCopy = "作成済の案件からコピーする";
  static const String constructionName = "工事名";
  static const String constructionType = "工種";
  static const String station = "測点";
  static const String shootingDate = "撮影日";
  static const String constructionSite = "工事場所";
  static const String builder = "施工者";
  static const String shootingPlace = "撮影場所";
  static const String shootingContent = "撮影内容";
  static const String contractor = "受注者";
}

abstract class LangCaseSetting {
  static const String addLocationInformation = '位置情報を付ける';
  static const String useBlackBoard = '黒板表示';
  static const String saveOriginalPhoto = '黒板なし写真を同時保存する';
  static const String tamperProof = '改ざん防止';
  static const String blackboardHasNotBeenSetYet = "デフォルト黒板を設定してください";
  static const String possessionServiceNotAllowed = "ポシショニングサービスが許可されません";
}

abstract class LangRequestPermission {
  static const String systemSettings = 'システム設定';
  static const String pleaseOpenIt = 'でオンにしてください';
}
