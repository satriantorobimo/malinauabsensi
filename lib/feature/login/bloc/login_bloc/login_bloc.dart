import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/login/domain/login_repo.dart';

import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginState get initialState => LoginInitial();
  LoginRepo loginRepo = LoginRepo();
  LoginBloc({required this.loginRepo}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginAttempt) {
        try {
          emit(LoginLoading());
          final loginResponseModel =
              await loginRepo.attemptLoginEmail(event.loginRequestModel);
          if (loginResponseModel!.status == '200') {
            emit(LoginLoaded(loginResponseModel: loginResponseModel));
          } else {
            emit(LoginError(loginResponseModel.message));
          }
        } catch (e) {
          emit(LoginException(e.toString()));
        }
      }
    });
  }
}
