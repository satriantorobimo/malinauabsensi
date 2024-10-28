import 'dart:convert';

import 'package:malinau_absensi/feature/login/data/login_request_model.dart';
import 'package:malinau_absensi/feature/login/data/login_response_model.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  LoginResponseModel loginResponseModel = LoginResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<LoginResponseModel> attemptLoginEmail(
      LoginRequestModel loginRequestModel) async {
    final Map<String, String> header = urlUtil.getHeaderType();
    final Map mapData = {};
    mapData['email'] = loginRequestModel.email;
    mapData['password'] = loginRequestModel.password;
    final json = jsonEncode(mapData);

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlLogin()),
          body: json, headers: header);
      if (res.statusCode == 200) {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(res.body));
        return loginResponseModel;
      } else {
        loginResponseModel = LoginResponseModel.fromJson(jsonDecode(res.body));
        throw loginResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
