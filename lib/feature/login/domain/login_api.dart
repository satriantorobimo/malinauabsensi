import 'dart:convert';

import 'package:malinau_absensi/feature/login/data/login_request_model.dart';
import 'package:malinau_absensi/feature/login/data/login_response_model.dart';
import 'package:malinau_absensi/feature/login/data/user_detail_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  LoginResponseModel loginResponseModel = LoginResponseModel();
  UserDetailResponseModel userDetailResponseModel = UserDetailResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<LoginResponseModel> attemptLoginEmail(
      LoginRequestModel loginRequestModel) async {
    final Map<String, String> header = urlUtil.getHeaderType();
    final Map mapData = {};
    if (loginRequestModel.email.isNotEmpty || loginRequestModel.email == '') {
      mapData['email'] = loginRequestModel.email;
      mapData['password'] = loginRequestModel.password;
    } else {
      mapData['nip'] = loginRequestModel.nip;
      mapData['password'] = loginRequestModel.password;
    }

    final json = jsonEncode(mapData);

    try {
      final res = await http.post(
          Uri.parse(loginRequestModel.email.isNotEmpty ||
                  loginRequestModel.email == ''
              ? urlUtil.getUrlLogin()
              : urlUtil.getUrlLoginNip()),
          body: json,
          headers: header);
      if (res.statusCode == 200) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(res.body));
        return loginResponseModel;
      } else {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(res.body));
        return loginResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<UserDetailResponseModel> attemptUserDetail() async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);

    try {
      final res = await http.get(Uri.parse(urlUtil.getUrlUserDetail(userid!)),
          headers: header);
      if (res.statusCode == 200) {
        userDetailResponseModel =
            UserDetailResponseModel.fromJson(jsonDecode(res.body));
        return userDetailResponseModel;
      } else if (res.statusCode == 401) {
        userDetailResponseModel =
            UserDetailResponseModel.fromJson(jsonDecode(res.body));
        return userDetailResponseModel;
      } else {
        userDetailResponseModel =
            UserDetailResponseModel.fromJson(jsonDecode(res.body));
        return userDetailResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
