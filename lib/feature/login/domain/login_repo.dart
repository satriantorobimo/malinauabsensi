import 'package:malinau_absensi/feature/login/data/login_request_model.dart';
import 'package:malinau_absensi/feature/login/data/login_response_model.dart';
import 'package:malinau_absensi/feature/login/domain/login_api.dart';

class LoginRepo {
  final LoginApi loginApi = LoginApi();

  Future<LoginResponseModel?> attemptLoginEmail(
          LoginRequestModel loginRequestModel) =>
      loginApi.attemptLoginEmail(loginRequestModel);
}
