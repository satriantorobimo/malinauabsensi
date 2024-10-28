import 'dart:convert';

import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class AbsenApi {
  AbsenResponseModel absenResponseModel = AbsenResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<AbsenResponseModel> attemptAbsenIn(
      AbsenRequestModel absenRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);
    final Map mapData = {};
    mapData['qr_content'] = absenRequestModel.qrContent;
    mapData['request_type'] = absenRequestModel.requestType;
    final json = jsonEncode(mapData);

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlCheckIn(userid!)),
          body: json, headers: header);
      if (res.statusCode == 200) {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        return absenResponseModel;
      } else {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        throw absenResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AbsenResponseModel> attemptAbsenOut(
      AbsenRequestModel absenRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);
    final Map mapData = {};
    mapData['qr_content'] = absenRequestModel.qrContent;
    mapData['request_type'] = absenRequestModel.requestType;
    final json = jsonEncode(mapData);

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlCheckOut(userid!)),
          body: json, headers: header);
      if (res.statusCode == 200) {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        return absenResponseModel;
      } else {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        throw absenResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
