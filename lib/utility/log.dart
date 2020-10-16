import 'package:logging/logging.dart';

class Log {
  static const String _NAME = 'Logger';
  static Logger _instance;

  static void init() {

    hierarchicalLoggingEnabled = true;
    _instance = Logger(_NAME);
    _instance.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  static void setLevel(Level level) {
//    Logger.root.level = level;
    _instance.level = level;
  }

  static void info(message, [Object error, StackTrace stackTrace]) {
    _instance.info(message, error, stackTrace);
  }

  static void warning(message, [Object error, StackTrace stackTrace]) {
    _instance.warning(message, error, stackTrace);
  }

  static void config(message, [Object error, StackTrace stackTrace]) {
    _instance.config(message, error, stackTrace);
  }

  static void fine(message, [Object error, StackTrace stackTrace]) {
    _instance.fine(message, error, stackTrace);
  }

  static void finer(message, [Object error, StackTrace stackTrace]) {
    _instance.finer(message, error, stackTrace);
  }

  static void finest(message, [Object error, StackTrace stackTrace]) {
    _instance.finest(message, error, stackTrace);
  }

  static void severe(message, [Object error, StackTrace stackTrace]) {
    _instance.severe(message, error, stackTrace);
  }

  static void shout(message, [Object error, StackTrace stackTrace]) {
    _instance.shout(message, error, stackTrace);
  }
}
