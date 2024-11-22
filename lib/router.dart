import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:malinau_absensi/feature/absensi/data/arguments_absen_model.dart';
import 'package:malinau_absensi/feature/absensi/data/user_availability_response_model.dart';
import 'package:malinau_absensi/feature/absensi/screen/absensi_screen.dart';
import 'package:malinau_absensi/feature/absensi_detail/screen/absensi_detail_screen.dart';
import 'package:malinau_absensi/feature/absensi_keluar/screen/absensi_keluar_screen.dart';
import 'package:malinau_absensi/feature/aktifitas_detail/screen/aktifitas_detail_screen.dart';
import 'package:malinau_absensi/feature/aktifitas_detail/screen/dinas_luar_detail_screen.dart';
import 'package:malinau_absensi/feature/face_scan/screen/face_scan_screen.dart';
import 'package:malinau_absensi/feature/face_scan/screen/face_scan_v2_screen.dart';
import 'package:malinau_absensi/feature/face_scan/screen/register_face_left_scan.dart';
import 'package:malinau_absensi/feature/face_scan/screen/register_face_right_scan.dart';
import 'package:malinau_absensi/feature/face_scan/screen/register_face_scan.dart';
import 'package:malinau_absensi/feature/face_scan/screen/register_face_scan_v2.dart';
import 'package:malinau_absensi/feature/face_scan/screen/register_face_scan_v3.dart';
import 'package:malinau_absensi/feature/face_scan/screen/success_scan_screen.dart';
import 'package:malinau_absensi/feature/izin/data/izin_list_response_model.dart'
    as izin;
import 'package:malinau_absensi/feature/izin_detail/screen/izin_detail_screen.dart';
import 'package:malinau_absensi/feature/login/screen/login_screen.dart';
import 'package:malinau_absensi/feature/permohonan_aktifitas_detail/screen/permohonan_aktifitas_detail_screen.dart';
import 'package:malinau_absensi/feature/permohonan_izin_detail/screen/permohonan_izin_detail.dart';
import 'package:malinau_absensi/feature/profile/profile_screen.dart';
import 'package:malinau_absensi/feature/qr_scan/screen/qr_scan_screen.dart';
import 'package:malinau_absensi/feature/setting/setting_screen.dart';
import 'package:malinau_absensi/feature/splash/splash_screen.dart';
import 'package:malinau_absensi/feature/tab/screen/tab_screen.dart';
import 'package:malinau_absensi/feature/tab/screen/tab_v2_screen.dart';
import 'package:malinau_absensi/feature/tambah_izin/screen/edit_izin_screen.dart';
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
            pageBuilder: (_, __, ___) => const CustomBottomNavBar(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.absenScreenRoute:
        final Data dataUser = settings.arguments as Data;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => AbsesnsiScreen(dataUser: dataUser),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.absenKeluarScreenRoute:
        final Data dataUser = settings.arguments as Data;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) =>
                AbsesnsiKeluarScreen(dataUser: dataUser),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.faceScanScreenRoute:
        final ArgumentAbsenModel argumentAbsenModel =
            settings.arguments as ArgumentAbsenModel;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => FaceScanV2Screen(
                  argumentAbsenModel: argumentAbsenModel,
                ), //FaceScanScreen
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.faceRegisterScanScreenRoute:
        final CameraDescription camera =
            settings.arguments as CameraDescription;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => RegisterFaceScanV3(
                camera: camera), //RegisterFaceScan(camera: camera),
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
        final String id = settings.arguments as String;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => AbsesnsiDetailScreen(id: id),
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
        final String id = settings.arguments as String;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => AktifitasDetailScreen(id: id),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.dinasLuarDetailScreenRoute:
        final String id = settings.arguments as String;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => DinasLuarDetailScreen(id: id),
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
        final izin.Data dataIzin = settings.arguments as izin.Data;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => IzinDetailScreen(data: dataIzin),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));

      case StringRouterUtil.editDetailScreenRoute:
        final izin.Data dataIzin = settings.arguments as izin.Data;
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => EditIzinScreen(data: dataIzin),
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

      case StringRouterUtil.settingScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const SettingScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(opacity: a, child: c));
      case StringRouterUtil.profileScreenRoute:
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => const ProfileScreen(),
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
