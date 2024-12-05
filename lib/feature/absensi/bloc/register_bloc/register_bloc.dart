import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterState get initialState => RegisterRegisteritial();
  AbsenRepo absenRepo = AbsenRepo();
  RegisterBloc({required this.absenRepo}) : super(RegisterRegisteritial()) {
    on<RegisterEvent>((event, emit) async {
      if (event is RegisterAttempt) {
        try {
          emit(RegisterLoading());
          final generalResponseModel =
              await absenRepo.attemptRegister(event.capturedImages);
          if (generalResponseModel!.status == 'success') {
            emit(RegisterLoaded(generalResponseModel: generalResponseModel));
          } else {
            emit(RegisterError(generalResponseModel.message));
          }
        } catch (e) {
          emit(RegisterException(e.toString()));
        }
      }
    });
  }
}
