import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'bloc.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  UpdateState get initialState => UpdateUpdateitial();
  AbsenRepo absenRepo = AbsenRepo();
  UpdateBloc({required this.absenRepo}) : super(UpdateUpdateitial()) {
    on<UpdateEvent>((event, emit) async {
      if (event is UpdateAttempt) {
        try {
          emit(UpdateLoading());
          final generalResponseModel =
              await absenRepo.attemptUpdateAbsen(event.updateAbsenRequestModel);
          if (generalResponseModel!.status == '200') {
            emit(UpdateLoaded(generalResponseModel: generalResponseModel));
          } else {
            emit(UpdateError(generalResponseModel.message));
          }
        } catch (e) {
          emit(UpdateException(e.toString()));
        }
      }
    });
  }
}
