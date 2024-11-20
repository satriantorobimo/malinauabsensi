import 'package:flutter/foundation.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_list_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_response_model.dart';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_api.dart';

class AbsenRepo {
  final AbsenApi absenApi = AbsenApi();

  Future<AbsenResponseModel?> attemptAbsenIn(
          AbsenRequestModel absenRequestModel) =>
      absenApi.attemptAbsenIn(absenRequestModel);

  Future<AbsenResponseModel?> attemptAbsenOut(
          AbsenRequestModel absenRequestModel) =>
      absenApi.attemptAbsenOut(absenRequestModel);

  Future<AbsenListResponseModel?> attemptAbsenList(String start, String end) =>
      absenApi.attemptAbsenList(start, end);

  Future<AbsenDetailResponseModel?> attemptAbsenDetail(String id) =>
      absenApi.attemptAbsenDetail(id);

  Future<String?> attemptRegister(Map<String, Uint8List> capturedImages) =>
      absenApi.attemptRegister(capturedImages);
}
