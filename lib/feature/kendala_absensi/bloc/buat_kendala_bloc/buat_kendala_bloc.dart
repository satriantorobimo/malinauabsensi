import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/kendala_absensi/domain/kendala_absen_repo.dart';
import 'bloc.dart';

class BuatKendalaBloc extends Bloc<BuatKendalaEvent, BuatKendalaState> {
  BuatKendalaState get initialState => BuatKendalaBuatKendalaitial();
  KendalaAbsenRepo kendalaAbsenRepo = KendalaAbsenRepo();
  BuatKendalaBloc({required this.kendalaAbsenRepo})
      : super(BuatKendalaBuatKendalaitial()) {
    on<BuatKendalaEvent>((event, emit) async {
      if (event is BuatKendalaAttempt) {
        try {
          emit(BuatKendalaLoading());
          final generalResponseModel = await kendalaAbsenRepo
              .attemptBuatKendalaAbsen(event.buatKendalaAbsenRequestModel);
          if (generalResponseModel!.status == '201') {
            emit(BuatKendalaLoaded(generalResponseModel: generalResponseModel));
          } else {
            emit(BuatKendalaError(generalResponseModel.message));
          }
        } catch (e) {
          emit(BuatKendalaException(e.toString()));
        }
      }
    });
  }
}
