import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'bloc.dart';

class AvailBloc extends Bloc<AvailEvent, AvailState> {
  AvailState get initialState => AvailAvailitial();
  AbsenRepo absenRepo = AbsenRepo();
  AvailBloc({required this.absenRepo}) : super(AvailAvailitial()) {
    on<AvailEvent>((event, emit) async {
      if (event is AvailAttempt) {
        try {
          emit(AvailLoading());
          final userAvailabilityResponseModel =
              await absenRepo.attemptUserAvailability();
          if (userAvailabilityResponseModel!.status == '200') {
            emit(AvailLoaded(
                userAvailabilityResponseModel: userAvailabilityResponseModel));
          } else {
            emit(AvailError(userAvailabilityResponseModel.message));
          }
        } catch (e) {
          emit(AvailException(e.toString()));
        }
      }
    });
  }
}
