import 'package:flutter/material.dart';
import 'package:malinau_absensi/util/string_router_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    cekData();
    super.initState();
  }

  void cekData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('token') != null) {
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, StringRouterUtil.tabScreenRoute, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, StringRouterUtil.loginScreenRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
