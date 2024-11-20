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
          String? result =
              await absenRepo.attemptRegister(event.capturedImages);
          if (result == 'Successfully uploaded image') {
            emit(RegisterLoaded(result: result!));
          } else {
            emit(RegisterError(result));
          }
        } catch (e) {
          emit(RegisterException(e.toString()));
        }
      }
    });
  }
}
