import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/izin/domain/izin_repo.dart';
import 'bloc.dart';

class TambahIzinBloc extends Bloc<TambahIzinEvent, TambahIzinState> {
  TambahIzinState get initialState => TambahIzinTambahIzinitial();
  IzinRepo izinRepo = IzinRepo();
  TambahIzinBloc({required this.izinRepo})
      : super(TambahIzinTambahIzinitial()) {
    on<TambahIzinEvent>((event, emit) async {
      if (event is TambahIzinAttempt) {
        try {
          emit(TambahIzinLoading());
          final generalResponseModel =
              await izinRepo.attemptTambahIzin(event.tambahIzinRequestModel);
          if (generalResponseModel!.status == 'success') {
            emit(TambahIzinLoaded(generalResponseModel: generalResponseModel));
          } else {
            emit(TambahIzinError(generalResponseModel.message));
          }
        } catch (e) {
          emit(TambahIzinException(e.toString()));
        }
      }

      if (event is EditIzinAttempt) {
        try {
          emit(TambahIzinLoading());
          final generalResponseModel =
              await izinRepo.attemptEditIzin(event.tambahIzinRequestModel);
          if (generalResponseModel!.status == 'success') {
            emit(EditIzinLoaded(generalResponseModel: generalResponseModel));
          } else {
            emit(TambahIzinError(generalResponseModel.message));
          }
        } catch (e) {
          emit(TambahIzinException(e.toString()));
        }
      }

      if (event is DeleteIzinAttempt) {
        try {
          emit(DeleteIzinLoading());
          final generalResponseModel =
              await izinRepo.attemptDeleteIzin(event.id);
          if (generalResponseModel!.status == 'success') {
            emit(DeleteIzinLoaded(generalResponseModel: generalResponseModel));
          } else {
            emit(TambahIzinError(generalResponseModel.message));
          }
        } catch (e) {
          emit(TambahIzinException(e.toString()));
        }
      }
    });
  }
}
