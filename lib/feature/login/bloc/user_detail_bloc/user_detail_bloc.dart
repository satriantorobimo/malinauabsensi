import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/login/domain/login_repo.dart';

import 'bloc.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserDetailState get initialState => UserDetailInitial();
  LoginRepo loginRepo = LoginRepo();
  UserDetailBloc({required this.loginRepo}) : super(UserDetailInitial()) {
    on<UserDetailEvent>((event, emit) async {
      if (event is UserDetailAttempt) {
        try {
          emit(UserDetailLoading());
          final userDetailResponseModel = await loginRepo.attemptUserDetail();
          if (userDetailResponseModel!.status == 'success') {
            emit(UserDetailLoaded(
                userDetailResponseModel: userDetailResponseModel));
          } else {
            emit(UserDetailError(userDetailResponseModel.message));
          }
        } catch (e) {
          emit(UserDetailException(e.toString()));
        }
      }
    });
  }
}
