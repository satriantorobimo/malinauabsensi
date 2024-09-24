class StringRouterUtil {
  factory StringRouterUtil() => _instance;
  StringRouterUtil.internal();
  static final StringRouterUtil _instance = StringRouterUtil.internal();

  static const String splashScreenRoute = '/';
  static const String loginScreenRoute = 'login-route';
  static const String tabScreenRoute = 'tab-route';
  static const String absenScreenRoute = 'absen-route';
  static const String faceScanScreenRoute = 'face-scan-route';
}
