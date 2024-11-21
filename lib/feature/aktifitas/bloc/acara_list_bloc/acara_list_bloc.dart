import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/aktifitas/domain/aktifitas_repo.dart';
import 'bloc.dart';

class AcaraListBloc extends Bloc<AcaraListEvent, AcaraListState> {
  AcaraListState get initialState => AcaraListAcaraListitial();
  AktifitasARepo aktifitasARepo = AktifitasARepo();
  AcaraListBloc({required this.aktifitasARepo})
      : super(AcaraListAcaraListitial()) {
    on<AcaraListEvent>((event, emit) async {
      if (event is AcaraListAttempt) {
        try {
          emit(AcaraListLoading());
          final acaraListResponseModel =
              await aktifitasARepo.attemptAcaraList(event.start, event.end);
          if (acaraListResponseModel!.status == 'success') {
            emit(AcaraListLoaded(
                acaraListResponseModel: acaraListResponseModel));
          } else {
            emit(AcaraListError(acaraListResponseModel.message));
          }
        } catch (e) {
          emit(AcaraListException(e.toString()));
        }
      }
    });
  }
}
