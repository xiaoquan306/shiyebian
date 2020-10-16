import 'dart:io';

import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site_blackboard_app/config/routes.dart';
import 'package:site_blackboard_app/utility/application_profile.dart';
import 'package:site_blackboard_app/utility/db/blackboard_database_migration.dart';
import 'package:site_blackboard_app/utility/db/database_helper.dart';
import 'package:site_blackboard_app/utility/log.dart';
import 'package:sqflite/sqflite.dart';

abstract class App {
  static fluro.Router _router;
  static Database _db;
  static DatabaseHelper _dbHelper;
  static Directory _supportDirectory;
  static Directory _documentsDirectory;
  static Directory _emulatedDirector;
  static String _photoPath;
  static String _tmpPath;
  static String _exportPath;

  static fluro.Router get router => _router;

  static Future<Database> get db async {
    if (_dbHelper == null) {
      _dbHelper = DatabaseHelper(
          DotEnv().env['DB_NAME'], BlackBoardDatabaseMigration());
    }

    if (_db == null) {
      await _dbHelper.open();
      _db = _dbHelper.db;
    }

    return _db;
  }

  static Future<Directory> get supportDirectory async {
    if (_supportDirectory == null) {
      _supportDirectory = await getApplicationSupportDirectory();
    }
    return _supportDirectory;
  }

  static Future<Directory> get documentsDirectory async {
    if (_documentsDirectory == null) {
      _documentsDirectory = await getApplicationDocumentsDirectory();
    }
    return _documentsDirectory;
  }

  static Future<Directory> get emulatedDirector async {
    if (_emulatedDirector == null) {
      _emulatedDirector =
          Directory("/storage/emulated/0/Download/site.conit.app.blackboard");
    }
    return _emulatedDirector;
  }

  static Future<String> get photoPath async {
    if (_photoPath == null) {
      _photoPath = <String>[(await supportDirectory).path, 'photo'].join('/');
      if (!Directory(_photoPath).existsSync()) {
        Directory(_photoPath).createSync(recursive: true);
      }
    }
    return _photoPath;
  }

  static Future<String> get tmpPath async {
    if (_tmpPath == null) {
      _tmpPath = <String>[(await supportDirectory).path, 'tmp'].join('/');
      if (!Directory(_tmpPath).existsSync()) {
        Directory(_tmpPath).createSync(recursive: true);
      }
    }
    return _tmpPath;
  }

  static Future<String> get exportPath async {
    if (_exportPath == null) {
      if (ApplicationProfile.isIos) {
        _exportPath = <String>[(await documentsDirectory).path].join('/');
      } else {
        _exportPath = <String>[(await emulatedDirector).path].join('/');
      }
    }
    return _exportPath;
  }

  static final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  /// アプリ起動
  static start() async {
    _initLog();
    Log.info('Application start');

    await _initEnv();
    _initDebugTools();
    _initRouter();
  }

  /// アプリ終了
  static terminate() async {
    await _dbHelper?.close();
    Log.info('Application terminate');
  }

  /// ページ切り替え
  static Future<dynamic> navigateTo(BuildContext context, String url,
      {Map<String, dynamic> params,
      bool replace = false,
      bool clearStack = false,
      fluro.TransitionType transition,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    if (params == null) {
      params = {};
    }
    params.forEach((key, value) {
      switch (value) {
        case true:
          value = '1';
          break;
        case false:
          value = '0';
          break;
        default:
          value = value.toString();
      }
      params[key] = value;
    });
    String uri = Uri(path: url, queryParameters: params).toString();
    return _router.navigateTo(context, uri,
        replace: replace,
        clearStack: clearStack,
        transition: transition,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder);
  }

  /// ログの初期化
  static _initLog() {
    Log.init();

    if (ApplicationProfile.isDebug) {
      Log.setLevel(Level.ALL);
    } else {
      Log.setLevel(Level.WARNING);
    }
  }

  /// 実行環境の初期化
  static _initEnv() async {
    await DotEnv().load('.env');
  }

  /// デバッグツールの初期化
  static _initDebugTools() {
    if (ApplicationProfile.isDebug) {
      // Stetho.initialize();
    }
  }

  /// ルートの初期化
  static _initRouter() {
    _router = fluro.Router();
    Routes.configureRoutes(_router);
  }
}
