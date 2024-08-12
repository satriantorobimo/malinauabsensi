import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malinau_absensi/appconfig.dart';
import 'main.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
    // statusBarBrightness: Brightness.light,
  ));

  AppConfig(flavor: Flavor.DEV, values: FlavorValues(baseUrl: '', userId: ''));
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {});
}
