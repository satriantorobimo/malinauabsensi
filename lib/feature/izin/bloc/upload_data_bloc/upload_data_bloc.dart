import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/izin/domain/izin_repo.dart';
import 'bloc.dart';

class UploadDataBloc extends Bloc<UploadDataEvent, UploadDataState> {
  UploadDataState get initialState => UploadDataUploadDataitial();
  IzinRepo izinRepo = IzinRepo();
  UploadDataBloc({required this.izinRepo})
      : super(UploadDataUploadDataitial()) {
    on<UploadDataEvent>((event, emit) async {
      if (event is UploadDataAttempt) {
        try {
          emit(UploadDataLoading());
          final String? statusCode = await izinRepo
              .attemptUploadFile(event.uploadFileIzinRequestModel);
          if (statusCode == '201') {
            emit(const UploadDataLoaded(
                statusCode: 'Upload file pendukung berhasil'));
          } else {
            emit(const UploadDataError('File pendukung terlalu besar'));
          }
        } catch (e) {
          emit(UploadDataException(e.toString()));
        }
      }
    });
  }
}
