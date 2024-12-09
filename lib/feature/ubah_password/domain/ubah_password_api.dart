import 'dart:convert';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/ubah_password/data/ubah_password_request_model.dart';
import 'package:malinau_absensi/feature/ubah_password/data/ubah_password_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class UbahPasswordApi {
  UbahPasswordResponseModel ubahPasswordResponseModel = UbahPasswordResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<UbahPasswordResponseModel> attemptUbahPassword(
      UbahPasswordRequestModel ubahPasswordRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);
    final Map mapData = {};
    mapData['oldPassword'] = ubahPasswordRequestModel.password;
    mapData['password'] = ubahPasswordRequestModel.newPassword;
    final json = jsonEncode(mapData);

    try {
      final res = await http.patch(
          Uri.parse(urlUtil.getUrlUbahPassowrd(userid!)),
          headers: header,
          body: json);
      if (res.statusCode == 201) {
        ubahPasswordResponseModel =
            UbahPasswordResponseModel.fromJson(jsonDecode(res.body));
        return ubahPasswordResponseModel;
      } else if (res.statusCode == 401) {
        ubahPasswordResponseModel =
            UbahPasswordResponseModel.fromJson(jsonDecode(res.body));
        return ubahPasswordResponseModel;
      } else {
        ubahPasswordResponseModel =
            UbahPasswordResponseModel.fromJson(jsonDecode(res.body));
        return ubahPasswordResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
