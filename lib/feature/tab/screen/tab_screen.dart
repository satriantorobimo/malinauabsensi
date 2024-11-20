import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/fab_bottom_app_bar_comp.dart';
import 'package:malinau_absensi/feature/aktifitas/screen/aktifitas_screen.dart';
import 'package:malinau_absensi/feature/aktifitas/screen/dinas_luar_screen.dart';
import 'package:malinau_absensi/feature/beranda/beranda_screen.dart';
import 'package:malinau_absensi/feature/home/screen/home_screen.dart';
import 'package:malinau_absensi/feature/izin/screen/izin_screen.dart';
import 'package:malinau_absensi/feature/izin/screen/under_construction.dart';
import 'package:malinau_absensi/feature/tab/provider/tab_provider.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  Widget _getPage(int index) {
    if (index == 0) {
      return const BerandaScreen();
    }
    if (index == 1) {
      return const DinasLuarScreen();
    }
    if (index == 2) {
      return const IzinScreen();
    }
    if (index == 3) {
      return const AktifitasScreen();
    }
    if (index == 4) {
      return const HomeScreen();
    }

    return const BerandaScreen();
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarProvider = Provider.of<TabProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          // String? clockinstart =
          //     await SharedPrefUtil.getSharedString('clockinstart');

          // String? clockoutstart =
          //     await SharedPrefUtil.getSharedString('clockoutstart');

          // String? attendstatus =
          //     await SharedPrefUtil.getSharedString('attendstatus');

          // if (context.mounted) {
          //   if (GeneralUtil().isWithinCheckInTime(clockinstart!) &&
          //       attendstatus == 'Tidak Masuk') {
          //     SharedPrefUtil.saveSharedString('attendstatus', 'Masuk');
          //     Navigator.pushNamed(context, StringRouterUtil.absenScreenRoute,
          //         arguments: true);
          //   } else if (attendstatus == 'Masuk') {
          //     if (GeneralUtil().isWithinCheckInTime(clockoutstart!)) {
          //       Navigator.pushNamed(
          //           context, StringRouterUtil.absenKeluarScreenRoute,
          //           arguments: true);
          //     } else {
          //       GeneralUtil().showSnackBarError(
          //           context, 'Absen keluar start dari pukul $clockoutstart');
          //     }
          //   } else {
          //     Navigator.pushNamed(context, StringRouterUtil.absenScreenRoute,
          //         arguments: false);
          //   }
          // }
          bottomBarProvider.setPage(4);
          bottomBarProvider.setTab(4);
        },
        backgroundColor: primaryColor,
        child: SvgPicture.asset(
          'assets/icons/absen.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          height: 32,
          width: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Absensi',
        color: Colors.grey,
        selectedColor: primaryColor,
        onTabSelected: (index) {
          bottomBarProvider.setPage(index);
          bottomBarProvider.setTab(index);
        },
        items: [
          FABBottomAppBarComp(
              iconData: 'assets/icons/home.svg', text: 'Beranda'),
          FABBottomAppBarComp(
              iconData: 'assets/icons/activity.svg', text: 'Dinas Luar'),
          FABBottomAppBarComp(iconData: 'assets/icons/izin.svg', text: 'Izin'),
          FABBottomAppBarComp(iconData: 'assets/icons/izin.svg', text: 'Acara'),
        ],
        backgroundColor: Colors.white,
      ),
      body: _getPage(bottomBarProvider.page),
    );
  }
}
