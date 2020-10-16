import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:site_blackboard_app/views/blackboard/blackboard_editor_page.dart';
import 'package:site_blackboard_app/views/blackboard/blackboard_templates_page.dart';
import 'package:site_blackboard_app/views/blackboard/blackboards_copy_page.dart';
import 'package:site_blackboard_app/views/blackboard/blackboards_page.dart';
import 'package:site_blackboard_app/views/camera/camera_page.dart';
import 'package:site_blackboard_app/views/case/case_create_page.dart';
import 'package:site_blackboard_app/views/case/case_license_page.dart';
import 'package:site_blackboard_app/views/case/case_main_page.dart';
import 'package:site_blackboard_app/views/case/case_settings_page.dart';
import 'package:site_blackboard_app/views/case/case_update_page.dart';
import 'package:site_blackboard_app/views/case/cases_page.dart';
import 'package:site_blackboard_app/views/not_found_page.dart';
import 'package:site_blackboard_app/views/photo/construction_types_page.dart';
import 'package:site_blackboard_app/views/photo/photo_move_page.dart';
import 'package:site_blackboard_app/views/photo/photo_preview_page.dart';
import 'package:site_blackboard_app/views/photo/photos_page.dart';
import 'package:site_blackboard_app/views/test_page.dart';

/// ルート定義
abstract class Routes {
  // Test (Only dev mode)
  static const String test = '/test';

  /// ---------- 案件 --------------------------------------------------

  // 案件一覧(Home)
  static const String cases = '/';

  // 案件追加
  static const String caseCreate = '/case/create';
  // 案件編集
  static const String caseUpdate = '/case/update';
  // 案件のトップページ
  static const String caseMain = '/case/main';
  // 案件設定
  static const String caseSetting = '/case/setting';
  //オープンソースプロトコル
  static const String caseLicense = 'case/license';

  /// ---------- 撮影 --------------------------------------------------

  // 撮影
  static const String camera = '/camera';

  /// ---------- 黒板 --------------------------------------------------

  // 黒板一覧
  static const String blackboards = '/blackboards';
  // 黒板のテンプレート
  static const String blackboardTemplates = '/blackboard/templates';
  // 黒板エディタ
  static const String blackboardEditor = '/blackboard/editor';
  // 黒板コピー
  static const String blackboardCopy = '/layoutSelect';

  /// ---------- 写真 --------------------------------------------------

  // 職種一覧
  static const String constructionTypes = '/photo/construction_types';
  // 写真一覧
  static const String photos = '/photos';
  // 写真プレビュー
  static const String photoPreview = '/photo/preview';
  // 写真移動
  static const String photoMove = '/photo/move';

  /// ルートの定義
  static void configureRoutes(fluro.Router router) {
    // 404
    router.notFoundHandler = fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return NotFoundPage();
    });

    // Test (Only dev mode)
    router.define(test, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return TestPage();
    }));

    /// ---------- 案件 --------------------------------------------------

    // 案件一覧
    router.define(cases, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CasesPage();
    }));

    // 案件追加
    router.define(caseCreate, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CaseCreatePage();
    }));

    // 案件編集
    router.define(caseUpdate, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CaseUpdatePage(
          caseId: int.tryParse(params['caseId']?.first ?? ''));
    }));

    // 案件ホーム
    router.define(caseMain, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CaseMainPage(caseId: int.tryParse(params['caseId']?.first ?? ''));
    }));

    // 案件設定
    router.define(caseSetting, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CaseSettingPage(
          caseId: int.tryParse(params['caseId']?.first ?? ''));
    }));

    //オープンソースプロトコル
    router.define(caseLicense, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CaseLicensePage();
    }));

    /// ---------- 撮影 --------------------------------------------------

    // 撮影
    router.define(camera, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return CameraPage(caseId: int.tryParse(params['caseId']?.first ?? ''));
    }));

    /// ---------- 黒板 --------------------------------------------------

    // 黒板一覧
    router.define(blackboards, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return BlackboardsPage(
          caseId: int.tryParse(params['caseId']?.first ?? ''),
          fromCamera: params['fromCamera']?.first == '1');
    }));

    // 黒板のテンプレート
    router.define(blackboardTemplates, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return BlackboardTemplatesPage(
          caseId: int.tryParse(params['caseId']?.first ?? ''),
          caseName: params['caseName']?.first.toString());
    }));

    // 黒板エディタ
    router.define(blackboardEditor, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return BlackboardEditorPage(
          isCreate: params['isCreate']?.first == "1",
          caseId: int.tryParse(params['caseId']?.first ?? ''),
          blackboardId: int.tryParse(params['blackboardId']?.first ?? ''),
          blackboardTemplateId:
              int.tryParse(params['blackboardTemplateId']?.first ?? ''));
    }));
    // 黒板コピー
    router.define(blackboardCopy, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return BlackboardsCopyPage(
          caseId: int.tryParse(params['caseId']?.first),
          copyToCaseId: int.tryParse(params['copyToCaseId']?.first),
          fromBlackboardsPage: params['fromTemplatesPage']?.first == '1');
    }));

    /// ---------- 写真 --------------------------------------------------

    // 職種一覧
    router.define(constructionTypes, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return ConstructionTypesPage(
        caseId: int.tryParse(params['caseId']?.first),
      );
    }));

    // 写真一覧
    router.define(photos, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return PhotosPage(
        constructionTypeId:
            int.tryParse(params['constructionTypeId']?.first ?? ''),
        constructionTypeName: params['constructionTypeName']?.first,
        caseName: params['caseName']?.first,
      );
    }));

    // 写真プレビュー
    router.define(photoPreview, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return PhotoPreviewPage(
        path: params['path']?.first,
        size: int.tryParse(params['size']?.first),
        date: params['date']?.first,
        photoId: int.tryParse(params['photoId']?.first),
        photoPreviewList: params['photoPreviewList']?.first,
      );
    }));

    // 写真移動
    router.define(photoMove, handler: fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return PhotoMovePage(photoId: int.parse(params['photoId']?.first));
    }));
  }
}
