import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'bloc.dart';

class OutBloc extends Bloc<OutEvent, OutState> {
  OutState get initialState => OutOutitial();
  AbsenRepo absenRepo = AbsenRepo();
  OutBloc({required this.absenRepo}) : super(OutOutitial()) {
    on<OutEvent>((event, emit) async {
      if (event is OutAttempt) {
        try {
          emit(OutLoading());
          final absenResponseModel =
              await absenRepo.attemptAbsenOut(event.absenOutRequestModel);
          if (absenResponseModel!.status == '200') {
            emit(OutLoaded(absenResponseModel: absenResponseModel));
          } else {
            emit(OutError(absenResponseModel.message));
          }
        } catch (e) {
          emit(OutException(e.toString()));
        }
      }
    });
  }
}
