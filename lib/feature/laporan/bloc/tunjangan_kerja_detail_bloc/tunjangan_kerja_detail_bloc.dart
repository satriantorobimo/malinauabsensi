import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/laporan/domain/tunjangan_kinerja_repo.dart';
import 'bloc.dart';

class TunjanganKerjaDetailBloc
    extends Bloc<TunjanganKerjaDetailEvent, TunjanganKerjaDetailState> {
  TunjanganKerjaDetailState get initialState =>
      TunjanganKerjaDetailTunjanganKerjaDetailitial();
  TunjanganKinerjaRepo tunjanganKinerjaRepo = TunjanganKinerjaRepo();
  TunjanganKerjaDetailBloc({required this.tunjanganKinerjaRepo})
      : super(TunjanganKerjaDetailTunjanganKerjaDetailitial()) {
    on<TunjanganKerjaDetailEvent>((event, emit) async {
      if (event is TunjanganKerjaDetailAttempt) {
        try {
          final tunjanganKinerjaDetailResponseModel =
              await tunjanganKinerjaRepo.attemptDetailTunjangan(event.id);
          emit(TunjanganKerjaDetailLoaded(
              tunjanganKinerjaDetailResponseModel:
                  tunjanganKinerjaDetailResponseModel!));
        } catch (e) {
          emit(TunjanganKerjaDetailException(e.toString()));
        }
      }
    });
  }
}
