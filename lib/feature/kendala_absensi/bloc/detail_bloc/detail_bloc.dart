import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/kendala_absensi/domain/kendala_absen_repo.dart';
import 'bloc.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailState get initialState => DetailDetailitial();
  KendalaAbsenRepo kendalaAbsenRepo = KendalaAbsenRepo();
  DetailBloc({required this.kendalaAbsenRepo}) : super(DetailDetailitial()) {
    on<DetailEvent>((event, emit) async {
      if (event is KendalaDetailAttempt) {
        try {
          emit(DetailLoading());
          final kendalaAbsenDetailResponseModel =
              await kendalaAbsenRepo.attemptKendalaAbsenDetail(event.id);
          if (kendalaAbsenDetailResponseModel!.status == '200') {
            emit(DetailLoaded(
                kendalaAbsenDetailResponseModel:
                    kendalaAbsenDetailResponseModel));
          } else {
            emit(DetailError(kendalaAbsenDetailResponseModel.message));
          }
        } catch (e) {
          emit(DetailException(e.toString()));
        }
      }
    });
  }
}
