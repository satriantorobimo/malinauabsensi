import 'dart:convert';

import 'package:malinau_absensi/appconfig.dart';

class UrlUtil {
  static String baseUrl = AppConfig.instance.values.baseUrl!;

  static Map<String, String> headerType() =>
      {'Content-Type': 'application/json', 'Accept': 'application/json'};

  static Map<String, String> headerTypeBasicAuth(
          String username, String password) =>
      {
        "content-type": "application/json",
        "accept": "application/json",
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}'
      };

  static Map<String, String> headerTypeWithToken(String token, String userId) =>
      {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Userid': userId
      };

  static Map<String, String> headerTypeWithTokenNoUserId(String token) => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

  static Map<String, String> headerTypeForm() => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  Map<String, String> getHeaderTypeWithToken(String token, String userId) {
    return headerTypeWithToken(token, userId);
  }

  Map<String, String> getHeaderTypeWithTokenNoUserId(String token) {
    return headerTypeWithTokenNoUserId(token);
  }

  Map<String, String> getHeaderTypeBasicAuth(String username, String password) {
    return headerTypeBasicAuth(username, password);
  }

  Map<String, String> getHeaderTypeForm() {
    return headerTypeForm();
  }

  Map<String, String> getHeaderType() {
    return headerType();
  }

  static String urlLogin() => 'v1/login/email';

  String getUrlLogin() {
    final String getUrlLogin2 = urlLogin();
    return baseUrl + getUrlLogin2;
  }

  static String urlCheckIn(String data) => 'v1/user/$data/in';

  String getUrlCheckIn(String data) {
    final String urlCheckIn2 = urlCheckIn(data);
    return baseUrl + urlCheckIn2;
  }

  static String urlCheckOut(String data) => 'v1/user/$data/out';

  String getUrlCheckOut(String data) {
    final String urlCheckOut2 = urlCheckOut(data);
    return baseUrl + urlCheckOut2;
  }
}
