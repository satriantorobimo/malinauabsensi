import 'dart:convert';
import 'package:malinau_absensi/feature/aktifitas/data/acara_detail_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/data/acara_list_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_detail_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_list_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class AktifitasApi {
  DinasLuarListResponseModel dinasLuarListResponseModel =
      DinasLuarListResponseModel();

  DinasLuarDetailResponseModel dinasLuarDetailResponseModel =
      DinasLuarDetailResponseModel();

  AcaraListResponseModel acaraListResponseModel = AcaraListResponseModel();

  AcaraDetailResponseModel acaraDetailResponseModel =
      AcaraDetailResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<DinasLuarListResponseModel> attemptDinasLuarList(
      String start, String end) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);

    try {
      final res = await http.get(Uri.parse(urlUtil.getUrlDinasLuar(end, start)),
          headers: header);
      if (res.statusCode == 200) {
        dinasLuarListResponseModel =
            DinasLuarListResponseModel.fromJson(jsonDecode(res.body));
        return dinasLuarListResponseModel;
      } else {
        dinasLuarListResponseModel =
            DinasLuarListResponseModel.fromJson(jsonDecode(res.body));
        throw dinasLuarListResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<DinasLuarDetailResponseModel> attemptDinasLuarDetail(String id) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);

    try {
      final res = await http.get(Uri.parse(urlUtil.getUrlDinasLuarDetail(id)),
          headers: header);
      if (res.statusCode == 200) {
        dinasLuarDetailResponseModel =
            DinasLuarDetailResponseModel.fromJson(jsonDecode(res.body));
        return dinasLuarDetailResponseModel;
      } else {
        dinasLuarDetailResponseModel =
            DinasLuarDetailResponseModel.fromJson(jsonDecode(res.body));
        throw dinasLuarDetailResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AcaraListResponseModel> attemptAcaraList(
      String start, String end) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);

    try {
      final res = await http.get(Uri.parse(urlUtil.getUrlAcaraList(end, start)),
          headers: header);
      if (res.statusCode == 200) {
        acaraListResponseModel =
            AcaraListResponseModel.fromJson(jsonDecode(res.body));
        return acaraListResponseModel;
      } else {
        acaraListResponseModel =
            AcaraListResponseModel.fromJson(jsonDecode(res.body));
        throw acaraListResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AcaraDetailResponseModel> attemptAcaraDetail(String id) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);

    try {
      final res = await http.get(Uri.parse(urlUtil.getUrlAcaraDetail(id)),
          headers: header);
      if (res.statusCode == 200) {
        acaraDetailResponseModel =
            AcaraDetailResponseModel.fromJson(jsonDecode(res.body));
        return acaraDetailResponseModel;
      } else {
        acaraDetailResponseModel =
            AcaraDetailResponseModel.fromJson(jsonDecode(res.body));
        throw acaraDetailResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
