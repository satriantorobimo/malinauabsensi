import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/laporan/domain/tunjangan_kinerja_repo.dart';
import 'bloc.dart';

class TunjanganKerjaBloc
    extends Bloc<TunjanganKerjaEvent, TunjanganKerjaState> {
  TunjanganKerjaState get initialState => TunjanganKerjaTunjanganKerjaitial();
  TunjanganKinerjaRepo tunjanganKinerjaRepo = TunjanganKinerjaRepo();
  TunjanganKerjaBloc({required this.tunjanganKinerjaRepo})
      : super(TunjanganKerjaTunjanganKerjaitial()) {
    on<TunjanganKerjaEvent>((event, emit) async {
      if (event is TunjanganKerjaListAttempt) {
        try {
          emit(TunjanganKerjaLoading());
          final tunjanganKinerjaListResponseModel =
              await tunjanganKinerjaRepo.attemptListTunjangan();
          if (tunjanganKinerjaListResponseModel!.status == 'OK') {
            emit(TunjanganKerjaListLoaded(
                tunjanganKinerjaListResponseModel:
                    tunjanganKinerjaListResponseModel.data!));
          } else {
            emit(
                TunjanganKerjaError(tunjanganKinerjaListResponseModel.message));
          }
        } catch (e) {
          emit(TunjanganKerjaException(e.toString()));
        }
      }
    });
  }
}
