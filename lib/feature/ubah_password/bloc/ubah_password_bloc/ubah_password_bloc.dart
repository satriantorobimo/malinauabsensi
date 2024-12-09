import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/ubah_password/domain/ubah_password_repo.dart';
import 'bloc.dart';

class UbahPasswordBloc extends Bloc<UbahPasswordEvent, UbahPasswordState> {
  UbahPasswordState get initialState => UbahPasswordUbahPassworditial();
  UbahPasswordRepoRepo ubahPasswordRepoRepo = UbahPasswordRepoRepo();
  UbahPasswordBloc({required this.ubahPasswordRepoRepo})
      : super(UbahPasswordUbahPassworditial()) {
    on<UbahPasswordEvent>((event, emit) async {
      if (event is UbahPasswordAttempt) {
        try {
          emit(UbahPasswordLoading());
          final ubahPasswordResponseModel =
              await ubahPasswordRepoRepo.attemptUbahPassword(event.ubahPasswordRequestModel);
          if (ubahPasswordResponseModel!.status == '200') {
            emit(UbahPasswordLoaded(ubahPasswordResponseModel: ubahPasswordResponseModel));
          } else {
            emit(UbahPasswordError(ubahPasswordResponseModel.message));
          }
        } catch (e) {
          emit(UbahPasswordException(e.toString()));
        }
      }

    });
  }
}
