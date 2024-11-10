import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/aktifitas/domain/aktifitas_repo.dart';
import 'bloc.dart';

class DinasLuarDetailBloc
    extends Bloc<DinasLuarDetailEvent, DinasLuarDetailState> {
  DinasLuarDetailState get initialState =>
      DinasLuarDetailDinasLuarDetailitial();
  AktifitasARepo aktifitasARepo = AktifitasARepo();
  DinasLuarDetailBloc({required this.aktifitasARepo})
      : super(DinasLuarDetailDinasLuarDetailitial()) {
    on<DinasLuarDetailEvent>((event, emit) async {
      if (event is DinasLuarDetailAttempt) {
        try {
          emit(DinasLuarDetailLoading());
          final dinasLuarDetailResponseModel =
              await aktifitasARepo.attemptDinasLuarDetail(event.id);
          if (dinasLuarDetailResponseModel!.status == 'success') {
            emit(DinasLuarDetailLoaded(
                dinasLuarDetailResponseModel: dinasLuarDetailResponseModel));
          } else {
            emit(DinasLuarDetailError(dinasLuarDetailResponseModel.message));
          }
        } catch (e) {
          emit(DinasLuarDetailException(e.toString()));
        }
      }
    });
  }
}
