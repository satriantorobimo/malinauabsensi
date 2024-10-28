import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:malinau_absensi/feature/absensi/data/arguments_absen_model.dart';
import 'package:malinau_absensi/feature/absensi/screen/absensi_screen.dart';
import 'package:malinau_absensi/feature/absensi_detail/screen/absensi_detail_screen.dart';
import 'package:malinau_absensi/feature/absensi_keluar/screen/absensi_keluar_screen.dart';
import 'package:malinau_absensi/feature/aktifitas_detail/screen/aktifitas_detail_screen.dart';
import 'package:malinau_absensi/feature/face_scan/screen/face_scan_screen.dart';
import 'package:malinau_absensi/feature/face_scan/screen/register_face_left_scan.dart';
import 'package:malinau_absensi/feature/face_scan/screen/register_face_right_scan.dart';
import 'package:malinau_absensi/feature/face_scan/screen/register_face_scan.dart';
import 'package:malinau_absensi/feature/face_scan/screen/success_scan_screen.dart';
import 'package:malinau_absensi/feature/izin_detail/screen/izin_detail_screen.dart';
import 'package:malinau_absensi/feature/login/screen/login_screen.dart';
import 'package:malinau_absensi/feature/permohonan_aktifitas_detail/screen/permohonan_aktifitas_detail_screen.dart';
import 'package:malinau_absensi/feature/permohonan_izin_detail/screen/permohonan_izin_detail.dart';
import 'package:malinau_absensi/feature/qr_scan/screen/qr_scan_screen.dart';
import 'package:malinau_absensi/feature/splash/splash_screen.dart';
import 'package:malinau_absensi/feature/tab/screen/tab_screen.dart';
import 'package:malinau_absensi/feature/tambah_izin/screen/tambah_izin_screen.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case StringRouterUtil.splashScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const SplashScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.loginScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.tabScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const TabScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.absenScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const AbsesnsiScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.absenKeluarScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const AbsesnsiKeluarScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.faceScanScreenRoute:
        final ArgumentAbsenModel argumentAbsenModel =
            settings.arguments as ArgumentAbsenModel;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => FaceScanScreen(
                  argumentAbsenModel: argumentAbsenModel,
                ),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.faceRegisterScanScreenRoute:
        final CameraDescription camera =
            settings.arguments as CameraDescription;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => RegisterFaceScan(camera: camera),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.faceRegisterRightScanScreenRoute:
        final CameraDescription camera =
            settings.arguments as CameraDescription;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => RegisterFaceRightScan(camera: camera),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.faceRegisterLeftScanScreenRoute:
        final CameraDescription camera =
            settings.arguments as CameraDescription;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => RegisterFaceLeftScan(camera: camera),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.absenDetailScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const AbsesnsiDetailScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.qrScanScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const QrScanScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.successScanScreenRoute:
        final bool isIn = settings.arguments as bool;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => SuccessScanScreen(
                  isIn: isIn,
                ),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.aktifitasDetailScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const AktifitasDetailScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.tambahIzinScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const TambahIzinScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.izinDetailScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const IzinDetailScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.permohonanIzinDetailScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const PermohonanIzinDetailScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.permohonanAktifitasDetailScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) =>
                const PermohonanAktifitasDetailScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      default:
        return MaterialPageRoute<dynamic>(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
