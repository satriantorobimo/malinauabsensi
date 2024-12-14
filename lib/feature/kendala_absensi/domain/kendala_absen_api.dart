import 'dart:convert';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/upload_file_izin_request_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/buat_kendala_absen_request_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/kendala_absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/kendala_absen_list_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/upload_file_kendala_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class KendalaAbsenApi {
  KendalaAbsenListResponseModel kendalaAbsenListResponseModel =
      KendalaAbsenListResponseModel();
  KendalaAbsenDetailResponseModel kendalaAbsenDetailResponseModel =
      KendalaAbsenDetailResponseModel();
  GeneralResponseModel generalResponseModel = GeneralResponseModel();
  UploadFileKendalaResponseModel uploadFileKendalaResponseModel =
      UploadFileKendalaResponseModel();

  UrlUtil urlUtil = UrlUtil();

  Future<KendalaAbsenListResponseModel> attemptKedanalaAbsenList(
      String start, String end) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);

    try {
      final res = await http.get(
          Uri.parse(urlUtil.getUrlKendalaAbsensiList(end, start)),
          headers: header);
      if (res.statusCode == 200) {
        kendalaAbsenListResponseModel =
            KendalaAbsenListResponseModel.fromJson(jsonDecode(res.body));
        return kendalaAbsenListResponseModel;
      } else if (res.statusCode == 401) {
        kendalaAbsenListResponseModel =
            KendalaAbsenListResponseModel.fromJson(jsonDecode(res.body));
        return kendalaAbsenListResponseModel;
      } else {
        kendalaAbsenListResponseModel =
            KendalaAbsenListResponseModel.fromJson(jsonDecode(res.body));
        return kendalaAbsenListResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<KendalaAbsenDetailResponseModel> attemptKendalaAbsenDetail(
      String id) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);

    try {
      final res = await http.get(
          Uri.parse(urlUtil.getUrlKendalaAbsensiDetail(id)),
          headers: header);
      if (res.statusCode == 200) {
        kendalaAbsenDetailResponseModel =
            KendalaAbsenDetailResponseModel.fromJson(jsonDecode(res.body));
        return kendalaAbsenDetailResponseModel;
      } else if (res.statusCode == 401) {
        kendalaAbsenDetailResponseModel =
            KendalaAbsenDetailResponseModel.fromJson(jsonDecode(res.body));
        return kendalaAbsenDetailResponseModel;
      } else {
        kendalaAbsenDetailResponseModel =
            KendalaAbsenDetailResponseModel.fromJson(jsonDecode(res.body));
        return kendalaAbsenDetailResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<GeneralResponseModel> attemptBuatKendalaAbsen(
      BuatKendalaAbsenRequestModel buatKendalaAbsenRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserIdNoJson(token!);
    final Map mapData = {};
    mapData['user_id'] = userid;
    mapData['description'] = buatKendalaAbsenRequestModel.description;
    mapData['status'] = 'Diproses';
    mapData['supported_file'] = buatKendalaAbsenRequestModel.supportedFile;
    mapData['attendance_date'] = buatKendalaAbsenRequestModel.attendanceDate;
    mapData['actions_to_do'] = [];
    final json = jsonEncode(mapData);

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlBuatKendalaAbsen()),
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

  Future<UploadFileKendalaResponseModel> attemptUploadFileKendala(
      UploadFileIzinRequestModel uploadFileIzinRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    Map<String, String> headers = {"Authorization": "Bearer $token"};

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(urlUtil.getUrlUploadFileKendala()),
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
        uploadFileKendalaResponseModel =
            UploadFileKendalaResponseModel.fromJson(jsonDecode(response.body));
        return uploadFileKendalaResponseModel;
      } else if (response.statusCode == 401) {
        uploadFileKendalaResponseModel =
            UploadFileKendalaResponseModel.fromJson(jsonDecode(response.body));
        return uploadFileKendalaResponseModel;
      } else {
        uploadFileKendalaResponseModel =
            UploadFileKendalaResponseModel.fromJson(jsonDecode(response.body));
        return uploadFileKendalaResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
