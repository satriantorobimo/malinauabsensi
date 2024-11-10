import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/aktifitas/domain/aktifitas_repo.dart';
import 'bloc.dart';

class DinasLuarListBloc extends Bloc<DinasLuarListEvent, DinasLuarListState> {
  DinasLuarListState get initialState => DinasLuarListDinasLuarListitial();
  AktifitasARepo aktifitasARepo = AktifitasARepo();
  DinasLuarListBloc({required this.aktifitasARepo})
      : super(DinasLuarListDinasLuarListitial()) {
    on<DinasLuarListEvent>((event, emit) async {
      if (event is DinasLuarListAttempt) {
        try {
          emit(DinasLuarListLoading());
          final dinasLuarListResponseModel = await aktifitasARepo
              .attemptDinasLuarList(event.page, event.limit);
          if (dinasLuarListResponseModel!.status == 'success') {
            emit(DinasLuarListLoaded(
                dinasLuarListResponseModel: dinasLuarListResponseModel));
          } else {
            emit(DinasLuarListError(dinasLuarListResponseModel.message));
          }
        } catch (e) {
          emit(DinasLuarListException(e.toString()));
        }
      }
    });
  }
}
