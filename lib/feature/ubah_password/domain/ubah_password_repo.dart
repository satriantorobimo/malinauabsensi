import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/ubah_password/data/ubah_password_request_model.dart';
import 'package:malinau_absensi/feature/ubah_password/data/ubah_password_response_model.dart';
import 'package:malinau_absensi/feature/ubah_password/domain/ubah_password_api.dart';

class UbahPasswordRepoRepo {
  final UbahPasswordApi ubahPasswordApi = UbahPasswordApi();

  Future<UbahPasswordResponseModel?> attemptUbahPassword(UbahPasswordRequestModel ubahPasswordRequestModel) =>
      ubahPasswordApi.attemptUbahPassword(ubahPasswordRequestModel);
}
