import 'dart:async';

import 'package:flutter/material.dart';
import 'package:malinau_absensi/util/string_router_util.dart';

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

  void cekData() {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(
          context, StringRouterUtil.loginScreenRoute, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
