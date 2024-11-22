import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/izin/domain/izin_repo.dart';
import 'bloc.dart';

class IzinListBloc extends Bloc<IzinListEvent, IzinListState> {
  IzinListState get initialState => IzinListIzinListitial();
  IzinRepo izinRepo = IzinRepo();
  IzinListBloc({required this.izinRepo}) : super(IzinListIzinListitial()) {
    on<IzinListEvent>((event, emit) async {
      if (event is IzinListAttempt) {
        try {
          emit(IzinListLoading());
          final izinListResponseModel =
              await izinRepo.attemptIzinList(event.start, event.end);
          if (izinListResponseModel!.status == 'success') {
            emit(IzinListLoaded(izinListResponseModel: izinListResponseModel));
          } else {
            emit(IzinListError(izinListResponseModel.message));
          }
        } catch (e) {
          emit(IzinListException(e.toString()));
        }
      }
    });
  }
}
