import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'bloc.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailState get initialState => DetailDetailitial();
  AbsenRepo absenRepo = AbsenRepo();
  DetailBloc({required this.absenRepo}) : super(DetailDetailitial()) {
    on<DetailEvent>((event, emit) async {
      if (event is DetailAttempt) {
        try {
          emit(DetailLoading());
          final absenDetailResponseModel =
              await absenRepo.attemptAbsenDetail(event.id);
          if (absenDetailResponseModel!.status == '200') {
            emit(DetailLoaded(
                absenDetailResponseModel: absenDetailResponseModel));
          } else {
            emit(DetailError(absenDetailResponseModel.message));
          }
        } catch (e) {
          emit(DetailException(e.toString()));
        }
      }
    });
  }
}
