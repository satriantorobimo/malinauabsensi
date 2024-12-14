import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/izin/data/upload_file_izin_request_model.dart';

abstract class UploadDataEvent extends Equatable {
  const UploadDataEvent();
}

class UploadDataAttempt extends UploadDataEvent {
  const UploadDataAttempt({required this.uploadFileIzinRequestModel});
  final UploadFileIzinRequestModel uploadFileIzinRequestModel;

  @override
  List<Object> get props => [uploadFileIzinRequestModel];
}

class UploadFileKendalaAttempt extends UploadDataEvent {
  const UploadFileKendalaAttempt({required this.uploadFileIzinRequestModel});
  final UploadFileIzinRequestModel uploadFileIzinRequestModel;

  @override
  List<Object> get props => [uploadFileIzinRequestModel];
}
