// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:malinau_absensi/util/string_util.dart';

enum Flavor { DEV, PRODUCTION }

class FlavorValues {
  FlavorValues({@required this.baseUrl, @required this.userId});
  final String? baseUrl;
  final String? userId;
}

class AppConfig {
  factory AppConfig(
      {@required Flavor? flavor, @required FlavorValues? values}) {
    _instance ??= AppConfig._internal(
        flavor!, StringUtil.enumName(flavor.toString()), values!);
    return _instance!;
  }
  const AppConfig._internal(this.flavor, this.name, this.values);
  static AppConfig get instance {
    return _instance!;
  }

  final Flavor flavor;
  final String name;
  final FlavorValues values;
  static AppConfig? _instance;

  static bool isProduction() => _instance!.flavor == Flavor.PRODUCTION;
  static bool isDevelopment() => _instance!.flavor == Flavor.DEV;
}
