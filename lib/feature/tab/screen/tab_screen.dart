import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/components/fab_bottom_app_bar_comp.dart';
import 'package:malinau_absensi/feature/aktifitas/screen/aktifitas_screen.dart';
import 'package:malinau_absensi/feature/home/screen/home_screen.dart';
import 'package:malinau_absensi/feature/izin/screen/izin_screen.dart';
import 'package:malinau_absensi/feature/laporan/screen/laporan_screen.dart';
import 'package:malinau_absensi/feature/tab/provider/tab_provider.dart';
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
      return const HomeScreen();
    }
    if (index == 1) {
      return const AktifitasScreen();
    }
    if (index == 2) {
      return const IzinScreen();
    }
    if (index == 3) {
      return const LaporanScreen();
    }

    return const HomeScreen();
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarProvider = Provider.of<TabProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pushNamed(context, StringRouterUtil.absenScreenRoute);
        },
        backgroundColor: primaryColor,
        child: SvgPicture.asset(
          'assets/icons/home.svg',
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          height: 24,
          width: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Absensi',
        color: Colors.grey,
        selectedColor: primaryColor,
        onTabSelected: (index) {
          bottomBarProvider.setPage(index);
          bottomBarProvider.setTab(0);
        },
        items: [
          FABBottomAppBarComp(
              iconData: 'assets/icons/home.svg', text: 'Beranda'),
          FABBottomAppBarComp(
              iconData: 'assets/icons/activity.svg', text: 'Aktivitas'),
          FABBottomAppBarComp(iconData: 'assets/icons/izin.svg', text: 'Izin'),
          FABBottomAppBarComp(
              iconData: 'assets/icons/izin.svg', text: 'Laporan'),
        ],
        backgroundColor: Colors.white,
      ),
      body: _getPage(bottomBarProvider.page),
    );
  }
}
