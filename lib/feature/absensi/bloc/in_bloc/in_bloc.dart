import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'bloc.dart';

class InBloc extends Bloc<InEvent, InState> {
  InState get initialState => InInitial();
  AbsenRepo absenRepo = AbsenRepo();
  InBloc({required this.absenRepo}) : super(InInitial()) {
    on<InEvent>((event, emit) async {
      if (event is InAttempt) {
        try {
          emit(InLoading());
          final absenResponseModel =
              await absenRepo.attemptAbsenIn(event.absenRequestModel);
          if (absenResponseModel!.status == '200') {
            emit(InLoaded(absenResponseModel: absenResponseModel));
          } else {
            emit(InError(absenResponseModel.message));
          }
        } catch (e) {
          emit(InException(e.toString()));
        }
      }
    });
  }
}
