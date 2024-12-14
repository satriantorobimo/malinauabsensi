import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/kendala_absensi/domain/kendala_absen_repo.dart';
import 'bloc.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListState get initialState => ListListitial();
  KendalaAbsenRepo kendalaAbsenRepo = KendalaAbsenRepo();
  ListBloc({required this.kendalaAbsenRepo}) : super(ListListitial()) {
    on<ListEvent>((event, emit) async {
      if (event is KendalaListAttempt) {
        try {
          emit(ListLoading());
          final kendalaAbsenListResponseModel = await kendalaAbsenRepo
              .attemptKedanalaAbsenList(event.start, event.end);
          if (kendalaAbsenListResponseModel!.status == '200') {
            emit(ListLoaded(
                kendalaAbsenListResponseModel: kendalaAbsenListResponseModel));
          } else {
            emit(ListError(kendalaAbsenListResponseModel.message));
          }
        } catch (e) {
          emit(ListException(e.toString()));
        }
      }
    });
  }
}
