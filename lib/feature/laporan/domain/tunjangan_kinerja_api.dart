import 'dart:convert';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_detail_response_model.dart.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_list_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class TunjanganKinerjaApi {
  TunjanganKinerjaDetailResponseModel tunjanganKinerjaDetailResponseModel =
      TunjanganKinerjaDetailResponseModel();
  TunjanganKinerjaListResponseModel tunjanganKinerjaListResponseModel =
      TunjanganKinerjaListResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<TunjanganKinerjaListResponseModel> attemptListTunjangan() async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);

    try {
      final res = await http.get(
        Uri.parse(urlUtil.getUrlListKinerja(userid!)),
        headers: header,
      );
      if (res.statusCode == 200) {
        tunjanganKinerjaListResponseModel =
            TunjanganKinerjaListResponseModel.fromJson(jsonDecode(res.body));
        return tunjanganKinerjaListResponseModel;
      } else if (res.statusCode == 401) {
        tunjanganKinerjaListResponseModel =
            TunjanganKinerjaListResponseModel.fromJson(jsonDecode(res.body));
        return tunjanganKinerjaListResponseModel;
      } else {
        tunjanganKinerjaListResponseModel =
            TunjanganKinerjaListResponseModel.fromJson(jsonDecode(res.body));
        return tunjanganKinerjaListResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<TunjanganKinerjaDetailResponseModel> attemptDetailTunjangan(
      String id) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);

    try {
      final res = await http.get(
        Uri.parse(urlUtil.getUrlDetailKinerja(id)),
        headers: header,
      );
      if (res.statusCode == 200) {
        tunjanganKinerjaDetailResponseModel =
            TunjanganKinerjaDetailResponseModel.fromJson(jsonDecode(res.body));
        return tunjanganKinerjaDetailResponseModel;
      } else if (res.statusCode == 401) {
        throw 'Token Expired';
      } else {
        tunjanganKinerjaDetailResponseModel =
            TunjanganKinerjaDetailResponseModel.fromJson(jsonDecode(res.body));
        return tunjanganKinerjaDetailResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
