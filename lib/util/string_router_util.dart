class StringRouterUtil {
  factory StringRouterUtil() => _instance;
  StringRouterUtil.internal();
  static final StringRouterUtil _instance = StringRouterUtil.internal();

  static const String splashScreenRoute = '/';
  static const String loginScreenRoute = 'login-route';
  static const String tabScreenRoute = 'tab-route';
  static const String absenScreenRoute = 'absen-route';
  static const String absenKeluarScreenRoute = 'absen-keluar-route';
  static const String faceScanScreenRoute = 'face-scan-route';
  static const String qrScanScreenRoute = 'qr-scan-route';
  static const String successScanScreenRoute = 'success-scan-route';
  static const String absenDetailScreenRoute = 'absen-detail-route';
  static const String aktifitasDetailScreenRoute = 'aktifitas-detail-route';
  static const String tambahIzinScreenRoute = 'tambah-izin-route';
  static const String izinDetailScreenRoute = 'izin-detail-route';
  static const String permohonanIzinDetailScreenRoute =
      'permohonan-izin-detail-route';
  static const String permohonanAktifitasDetailScreenRoute =
      'permohonan-aktifitas-detail-route';
}
