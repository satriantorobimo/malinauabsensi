import 'dart:convert';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/data/acara_detail_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/data/acara_list_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_detail_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_list_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/izin_list_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/tambah_izin_request_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class IzinApi {
  IzinListResponseModel izinListResponseModel = IzinListResponseModel();
  GeneralResponseModel generalResponseModel = GeneralResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<IzinListResponseModel> attemptIzinList(
      String start, String end) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);

    try {
      final res = await http.get(Uri.parse(urlUtil.getUrlIzin(end, start)),
          headers: header);
      if (res.statusCode == 200) {
        izinListResponseModel =
            IzinListResponseModel.fromJson(jsonDecode(res.body));
        return izinListResponseModel;
      } else {
        izinListResponseModel =
            IzinListResponseModel.fromJson(jsonDecode(res.body));
        throw izinListResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<GeneralResponseModel> attemptTambahIzin(
      TambahIzinRequestModel tambahIzinRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);
    final Map mapData = {};
    mapData['from_date'] = tambahIzinRequestModel.fromDate;
    mapData['to_date'] = tambahIzinRequestModel.toDate;
    mapData['type'] = tambahIzinRequestModel.type;
    mapData['remarks'] = tambahIzinRequestModel.remarks;
    final json = jsonEncode(mapData);

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlTambahIzin()),
          headers: header, body: json);
      if (res.statusCode == 201) {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
      } else {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        throw generalResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<GeneralResponseModel> attemptEditIzin(
      TambahIzinRequestModel tambahIzinRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);
    final Map mapData = {};
    mapData['from_date'] = tambahIzinRequestModel.fromDate;
    mapData['to_date'] = tambahIzinRequestModel.toDate;
    mapData['type'] = tambahIzinRequestModel.type;
    mapData['remarks'] = tambahIzinRequestModel.remarks;
    final json = jsonEncode(mapData);

    try {
      final res = await http.patch(
          Uri.parse(urlUtil.getUrlEditIzin(tambahIzinRequestModel.id!)),
          headers: header,
          body: json);
      if (res.statusCode == 200) {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
      } else {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        throw generalResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
