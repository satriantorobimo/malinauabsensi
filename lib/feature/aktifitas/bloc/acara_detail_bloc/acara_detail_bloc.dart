import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/aktifitas/domain/aktifitas_repo.dart';
import 'bloc.dart';

class AcaraDetailBloc extends Bloc<AcaraDetailEvent, AcaraDetailState> {
  AcaraDetailState get initialState => AcaraDetailAcaraDetailitial();
  AktifitasARepo aktifitasARepo = AktifitasARepo();
  AcaraDetailBloc({required this.aktifitasARepo})
      : super(AcaraDetailAcaraDetailitial()) {
    on<AcaraDetailEvent>((event, emit) async {
      if (event is AcaraDetailAttempt) {
        try {
          emit(AcaraDetailLoading());
          final acaraDetailResponseModel =
              await aktifitasARepo.attemptAcaraDetail(event.id);
          if (acaraDetailResponseModel!.status == 'success') {
            emit(AcaraDetailLoaded(
                acaraDetailResponseModel: acaraDetailResponseModel));
          } else {
            emit(AcaraDetailError(acaraDetailResponseModel.message));
          }
        } catch (e) {
          emit(AcaraDetailException(e.toString()));
        }
      }
    });
  }
}
