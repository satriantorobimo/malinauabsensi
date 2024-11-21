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

  static Map<String, String> headerTypeWithTokenNoUserIdNoJson(String token) =>
      {'Authorization': 'Bearer $token', 'Accept': '*/*'};

  static Map<String, String> headerTypeForm() => {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

  Map<String, String> getHeaderTypeWithToken(String token, String userId) {
    return headerTypeWithToken(token, userId);
  }

  Map<String, String> getHeaderTypeWithTokenNoUserId(String token) {
    return headerTypeWithTokenNoUserId(token);
  }

  Map<String, String> getHeaderTypeWithTokenNoUserIdNoJson(String token) {
    return headerTypeWithTokenNoUserIdNoJson(token);
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

  static String urlLoginNip() => 'v1/login/nip';

  String getUrlLoginNip() {
    final String getUrlLoginNip2 = urlLoginNip();
    return baseUrl + getUrlLoginNip2;
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

  static String urlUpdateAbsen(String id) => 'v2/attendance/$id';

  String getUrlUpdateAbsen(String id) {
    final String urlUpdateAbsen2 = urlUpdateAbsen(id);
    return baseUrl + urlUpdateAbsen2;
  }

  static String urlAcaraList(String start, String end) =>
      'v1/event?page=1&limit=500&start_date=$start&to_date=$end';

  String getUrlAcaraList(String start, String end) {
    final String urlAcaraList2 = urlAcaraList(start, end);
    return baseUrl + urlAcaraList2;
  }

  static String urlAcaraDetail(String id) => 'v1/event/$id';

  String getUrlAcaraDetail(String id) {
    final String urlAcaraDetail2 = urlAcaraDetail(id);
    return baseUrl + urlAcaraDetail2;
  }

  static String urlDinasLuar(String start, String end) =>
      'v2/dinas-luar?page=1&limit=500&start_date=$start&to_date=$end&status=Approved';

  String getUrlDinasLuar(String start, String end) {
    final String urlDinasLuar2 = urlDinasLuar(start, end);
    return baseUrl + urlDinasLuar2;
  }

  static String urlDinasLuarDetail(String id) => 'v2/dinas-luar/$id';

  String getUrlDinasLuarDetail(String id) {
    final String urlDinasLuarDetail2 = urlDinasLuarDetail(id);
    return baseUrl + urlDinasLuarDetail2;
  }

  static String urlAbsensiList(String id, String start, String end) =>
      'v2/attendance/$id/list?page=1&limit=500&start_date=$start&end_date=$end';

  String getUrlAbsensiList(String id, String start, String end) {
    final String urlAbsensiList2 = urlAbsensiList(id, start, end);
    return baseUrl + urlAbsensiList2;
  }

  static String urlAbsensiDetail(String id) => 'v1/attendance/$id';

  String getUrlAbsensiDetail(String id) {
    final String urlAbsensiDetail2 = urlAbsensiDetail(id);
    return baseUrl + urlAbsensiDetail2;
  }

  static String urlAbsensiAvail(String id) => 'v2/user/$id//availability';

  String getUrlAbsensiAvail(String id) {
    final String urlAbsensiAvail2 = urlAbsensiAvail(id);
    return baseUrl + urlAbsensiAvail2;
  }

  static String urlUserDetail(String id) => 'v1/user/$id';

  String getUrlUserDetail(String id) {
    final String urlUserDetail2 = urlUserDetail(id);
    return baseUrl + urlUserDetail2;
  }

  static String urlRegisterFace(String id) =>
      'https://api-dev.anydev.online/v1/user/$id/index_face_images';

  String getUrlRegisterFace(String id) {
    return urlRegisterFace(id);
  }
}
