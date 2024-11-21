import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:malinau_absensi/components/color_comp.dart';
import 'package:malinau_absensi/feature/aktifitas/screen/aktifitas_screen.dart';
import 'package:malinau_absensi/feature/aktifitas/screen/dinas_luar_screen.dart';
import 'package:malinau_absensi/feature/beranda/beranda_screen.dart';
import 'package:malinau_absensi/feature/home/screen/home_screen.dart';
import 'package:malinau_absensi/feature/izin/screen/izin_screen.dart';
import 'package:malinau_absensi/feature/tab/provider/tab_provider.dart';
import 'package:malinau_absensi/util/general_util.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<Map<String, dynamic>> _tabs = [
    {'label': 'Home', 'icon': 'assets/icons/home.svg'},
    {'label': 'Izin', 'icon': 'assets/icons/izin.svg'},
    {
      'label': 'Absensi',
      'icon': 'assets/icons/absen.svg',
      'isHighlighted': true
    },
    {'label': 'Dinas Luar', 'icon': 'assets/icons/activity.svg'},
    {'label': 'Acara', 'icon': 'assets/icons/izin.svg'},
  ];

  void _onTabTapped(int index) {
    var bottomBarProvider = Provider.of<TabProvider>(context, listen: false);
    bottomBarProvider.setPage(index);
    bottomBarProvider.setTab(index);
  }

  Widget _getPage(int index) {
    if (index == 0) {
      return const BerandaScreen();
    }
    if (index == 1) {
      return const IzinScreen();
    }
    if (index == 2) {
      return const HomeScreen();
    }
    if (index == 3) {
      return const DinasLuarScreen();
    }
    if (index == 4) {
      return const AktifitasScreen();
    }

    return const BerandaScreen();
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarProvider = Provider.of<TabProvider>(context);
    return Scaffold(
      body: _getPage(bottomBarProvider.page),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5), // Shadow is above the BottomAppBar
            ),
          ],
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: Colors.white,
          notchMargin: 8.0,
          elevation: 2,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _tabs.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> tab = entry.value;
                  bool isHighlighted = tab['isHighlighted'] ?? false;

                  if (isHighlighted) {
                    // Skip rendering the highlighted tab here
                    return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25);
                  }

                  return Expanded(
                    child: InkWell(
                      onTap: () => _onTabTapped(index),
                      splashColor: Colors.transparent, // Remove splash effect
                      highlightColor:
                          Colors.transparent, // Remove highlight effect
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              tab['icon'],
                              colorFilter: ColorFilter.mode(
                                  bottomBarProvider.page == index
                                      ? primaryColor
                                      : Colors.grey,
                                  BlendMode.dstIn),
                              width: 24,
                              height: 24,
                            ),
                          ),
                          Text(
                            tab['label'],
                            style: TextStyle(
                              fontSize: GeneralUtil.fontSize(context) * 0.3,
                              fontWeight: FontWeight.w400,
                              color: bottomBarProvider.page == index
                                  ? primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              Positioned(
                top: -45, // Move this up
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: InkWell(
                  splashColor: Colors.transparent, // Remove splash effect
                  highlightColor: Colors.transparent, // Remove highlight effect
                  onTap: () => _onTabTapped(2), // "Absensi" index
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/absen.svg',
                          colorFilter: const ColorFilter.mode(
                              primaryColor, BlendMode.dstIn),
                          width: 24,
                          height: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Absensi',
                        style: TextStyle(
                          fontSize: GeneralUtil.fontSize(context) * 0.3,
                          fontWeight: FontWeight.w400,
                          color: bottomBarProvider.page == 2
                              ? primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
