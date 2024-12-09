import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_list_response_model.dart';
import 'package:malinau_absensi/feature/laporan/domain/tunjangan_kinerja_repo.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
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
          final tunjanganKinerjaListResponseModel = await tunjanganKinerjaRepo
              .attemptListTunjangan(event.start, event.end);
          if (tunjanganKinerjaListResponseModel!.status == 'OK') {
            if (tunjanganKinerjaListResponseModel.data!.isNotEmpty) {
              final String? userid =
                  await SharedPrefUtil.getSharedString('userid');
              List<Data> listTunjangan = tunjanganKinerjaListResponseModel.data!
                  .where(
                    (element) => element.pegawaiId == userid,
                  )
                  .toList();
              emit(TunjanganKerjaListLoaded(
                  tunjanganKinerjaListResponseModel: listTunjangan));
            } else {
              emit(TunjanganKerjaListLoaded(
                  tunjanganKinerjaListResponseModel:
                      tunjanganKinerjaListResponseModel.data!));
            }
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
