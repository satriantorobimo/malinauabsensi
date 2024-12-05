import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_out_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_list_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_summary_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/update_absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/user_availability_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:malinau_absensi/util/url_util.dart';
import 'package:http/http.dart' as http;

class AbsenApi {
  AbsenResponseModel absenResponseModel = AbsenResponseModel();
  AbsenListResponseModel absenListResponseModel = AbsenListResponseModel();
  AbsenDetailResponseModel absenDetailResponseModel =
      AbsenDetailResponseModel();
  GeneralResponseModel generalResponseModel = GeneralResponseModel();
  UserAvailabilityResponseModel userAvailabilityResponseModel =
      UserAvailabilityResponseModel();
  AbsenSummaryResponseModel absenSummaryResponseModel =
      AbsenSummaryResponseModel();

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
    mapData['location'] = absenRequestModel.location;
    final json = jsonEncode(mapData);

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlCheckIn(userid!)),
          body: json, headers: header);
      if (res.statusCode == 200) {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        return absenResponseModel;
      } else if (res.statusCode == 401) {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        return absenResponseModel;
      } else {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        return absenResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AbsenResponseModel> attemptAbsenOut(
      AbsenOutRequestModel absenOutRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);
    final Map mapData = {};
    mapData['qr_content'] = absenOutRequestModel.qrContent;
    mapData['request_type'] = absenOutRequestModel.requestType;
    final json = jsonEncode(mapData);

    try {
      final res = await http.post(Uri.parse(urlUtil.getUrlCheckOut(userid!)),
          body: json, headers: header);
      if (res.statusCode == 200) {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        return absenResponseModel;
      } else if (res.statusCode == 401) {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        return absenResponseModel;
      } else {
        absenResponseModel = AbsenResponseModel.fromJson(jsonDecode(res.body));
        return absenResponseModel;
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
      } else if (res.statusCode == 401) {
        absenListResponseModel =
            AbsenListResponseModel.fromJson(jsonDecode(res.body));
        return absenListResponseModel;
      } else {
        absenListResponseModel =
            AbsenListResponseModel.fromJson(jsonDecode(res.body));
        return absenListResponseModel;
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
      } else if (res.statusCode == 401) {
        absenDetailResponseModel =
            AbsenDetailResponseModel.fromJson(jsonDecode(res.body));
        return absenDetailResponseModel;
      } else {
        absenDetailResponseModel =
            AbsenDetailResponseModel.fromJson(jsonDecode(res.body));
        return absenDetailResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<GeneralResponseModel> attemptRegister(
      Map<String, Uint8List> capturedImages) async {
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
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(response.body));
        return generalResponseModel;
      } else {
        generalResponseModel =
            GeneralResponseModel.fromJson(jsonDecode(response.body));
        return generalResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<GeneralResponseModel> attemptUpdateAbsen(
      UpdateAbsenRequestModel updateAbsenRequestModel) async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);
    final Map mapData = {};
    mapData['userID'] = userid;
    mapData['requestDate'] = updateAbsenRequestModel.requestDate;
    mapData['keterangan'] = updateAbsenRequestModel.keterangan;
    final json = jsonEncode(mapData);

    try {
      final res = await http.put(
          Uri.parse(urlUtil.getUrlUpdateAbsen(updateAbsenRequestModel.userID!)),
          body: json,
          headers: header);
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

  Future<UserAvailabilityResponseModel> attemptUserAvailability() async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);

    try {
      final res = await http.get(Uri.parse(urlUtil.getUrlAbsensiAvail(userid!)),
          headers: header);
      if (res.statusCode == 200) {
        userAvailabilityResponseModel =
            UserAvailabilityResponseModel.fromJson(jsonDecode(res.body));
        return userAvailabilityResponseModel;
      } else if (res.statusCode == 401) {
        userAvailabilityResponseModel =
            UserAvailabilityResponseModel.fromJson(jsonDecode(res.body));
        return userAvailabilityResponseModel;
      } else {
        userAvailabilityResponseModel =
            UserAvailabilityResponseModel.fromJson(jsonDecode(res.body));
        return userAvailabilityResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }

  Future<AbsenSummaryResponseModel> attemptAbsenSummary() async {
    final String? token = await SharedPrefUtil.getSharedString('token');
    final String? userid = await SharedPrefUtil.getSharedString('userid');
    final Map<String, String> header =
        urlUtil.getHeaderTypeWithTokenNoUserId(token!);

    try {
      final res = await http.get(
          Uri.parse(urlUtil.getUrlAbsensiSummary(userid!)),
          headers: header);
      if (res.statusCode == 200) {
        absenSummaryResponseModel =
            AbsenSummaryResponseModel.fromJson(jsonDecode(res.body));
        return absenSummaryResponseModel;
      } else if (res.statusCode == 401) {
        absenSummaryResponseModel =
            AbsenSummaryResponseModel.fromJson(jsonDecode(res.body));
        return absenSummaryResponseModel;
      } else {
        absenSummaryResponseModel =
            AbsenSummaryResponseModel.fromJson(jsonDecode(res.body));
        return absenSummaryResponseModel;
      }
    } catch (ex) {
      throw ex.toString();
    }
  }
}
