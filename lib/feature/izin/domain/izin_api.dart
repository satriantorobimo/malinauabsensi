import 'dart:convert';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/izin_list_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/tambah_izin_request_model.dart';
import 'package:malinau_absensi/feature/izin/data/upload_file_izin_request_model.dart';
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
      } else if (res.statusCode == 401) {
        izinListResponseModel =
            IzinListResponseModel.fromJson(jsonDecode(res.body));
        return izinListResponseModel;
      } else {
        izinListResponseModel =
            IzinListResponseModel.fromJson(jsonDecode(res.body));
        return izinListResponseModel;
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
      } else if (res.statusCode == 401) {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
      } else {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
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
        return generalResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<GeneralResponseModel> attemptDeleteIzin(String id) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);

    try {
      final res = await http.delete(
        Uri.parse(urlUtil.getUrlEditIzin(id)),
        headers: header,
      );
      if (res.statusCode == 200) {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
      } else if (res.statusCode == 401) {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
      } else {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(res.body));
        return generalResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<String> attemptUploadFile(
      UploadFileIzinRequestModel uploadFileIzinRequestModel) async {
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final String? token = await SharedPrefUtil.getSharedString('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(urlUtil.getUrlUploadFileIzin(userid!)),
      );
      request.headers.addAll(headers);
      var multipartFile = http.MultipartFile.fromBytes(
        'file', // Field name, e.g. 'file0', 'file1', etc.
        uploadFileIzinRequestModel.fileData, // The Uint8List image data
        filename:
            '${uploadFileIzinRequestModel.fileName}${uploadFileIzinRequestModel.fileType}', // You can change the extension if needed
      );

      request.files.add(multipartFile);
      // Send the request
      final streamedResponse = await request.send();

      // Convert the streamed response to a regular response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        return response.statusCode.toString();
      } else {
        return response.statusCode.toString();
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
