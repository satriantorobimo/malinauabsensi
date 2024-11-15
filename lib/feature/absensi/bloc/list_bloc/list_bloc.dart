import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'bloc.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListState get initialState => ListListitial();
  AbsenRepo absenRepo = AbsenRepo();
  ListBloc({required this.absenRepo}) : super(ListListitial()) {
    on<ListEvent>((event, emit) async {
      if (event is ListAttempt) {
        try {
          emit(ListLoading());
          final absenListResponseModel =
              await absenRepo.attemptAbsenList(event.start, event.end);
          if (absenListResponseModel!.status == '200') {
            emit(ListLoaded(absenListResponseModel: absenListResponseModel));
          } else {
            emit(ListError(absenListResponseModel.message));
          }
        } catch (e) {
          emit(ListException(e.toString()));
        }
      }
    });
  }
}
