import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_list_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class AbsenApi {
  AbsenResponseModel absenResponseModel = AbsenResponseModel();
  AbsenListResponseModel absenListResponseModel = AbsenListResponseModel();
  AbsenDetailResponseModel absenDetailResponseModel =
      AbsenDetailResponseModel();
  GeneralResponseModel generalResponseModel = GeneralResponseModel();

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

  Future<AbsenListResponseModel> attemptAbsenList(
      String start, String end) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);

    try {
      final res = await http.get(
          Uri.parse(urlUtil.getUrlAbsensiList(userid!, end, start)),
          headers: header);
      if (res.statusCode == 200) {
        absenListResponseModel =
            AbsenListResponseModel.fromJson(jsonDecode(res.body));
        return absenListResponseModel;
      } else {
        absenListResponseModel =
            AbsenListResponseModel.fromJson(jsonDecode(res.body));
        throw absenListResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AbsenDetailResponseModel> attemptAbsenDetail(String id) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);

    try {
      final res = await http.get(Uri.parse(urlUtil.getUrlAbsensiDetail(id)),
          headers: header);
      if (res.statusCode == 200) {
        absenDetailResponseModel =
            AbsenDetailResponseModel.fromJson(jsonDecode(res.body));
        return absenDetailResponseModel;
      } else {
        absenDetailResponseModel =
            AbsenDetailResponseModel.fromJson(jsonDecode(res.body));
        throw absenDetailResponseModel.message!;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<String> attemptRegister(Map<String, Uint8List> capturedImages) async {
    final String? userid = await SharedPrefUtil.getSharedString('userid');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(urlUtil.getUrlRegisterFace(userid!)),
      );
      capturedImages.forEach((imageName, imageData) async {
        // Create a MultipartFile from the Uint8List image data
        var multipartFile = http.MultipartFile.fromBytes(
          imageName, // Field name, e.g. 'file0', 'file1', etc.
          imageData, // The Uint8List image data
          filename: '$imageName.jpg', // You can change the extension if needed
        );

        request.files.add(multipartFile);
      });

      // Send the request
      final streamedResponse = await request.send();

      // Convert the streamed response to a regular response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw response.body;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
