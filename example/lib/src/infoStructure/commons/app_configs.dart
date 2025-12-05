// app/app_configs.dart

class AppConfigs {
 // static String get baseUrl => 'http://192.168.97.179:3000';
  static String get baseUrl => 'http://localhost:3000';

  // تنظیمات عموم
  static const int connectTimeout = 15;
  static const int receiveTimeout = 15;
  static const int defaultTimeout = 30;
  static const int extendedTimeout = 120;

  static const bool isDebug = true;

  static bool get isShowLog => isDebug;
}
