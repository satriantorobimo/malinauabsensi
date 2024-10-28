import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_response_model.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_api.dart';

class AbsenRepo {
  final AbsenApi absenApi = AbsenApi();

  Future<AbsenResponseModel?> attemptAbsenIn(
          AbsenRequestModel absenRequestModel) =>
      absenApi.attemptAbsenIn(absenRequestModel);

  Future<AbsenResponseModel?> attemptAbsenOut(
          AbsenRequestModel absenRequestModel) =>
      absenApi.attemptAbsenOut(absenRequestModel);
}
