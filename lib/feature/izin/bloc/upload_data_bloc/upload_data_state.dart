import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/upload_file_kendala_response_model.dart';

abstract class UploadDataState extends Equatable {
  const UploadDataState();

  @override
  List<Object> get props => [];
}

class UploadDataUploadDataitial extends UploadDataState {}

class UploadDataLoading extends UploadDataState {}

class UploadDataLoaded extends UploadDataState {
  const UploadDataLoaded({required this.statusCode});
  final String statusCode;
  @override
  List<Object> get props => [statusCode];
}

class UploadDataKendalaLoaded extends UploadDataState {
  const UploadDataKendalaLoaded({required this.uploadFileKendalaResponseModel});
  final UploadFileKendalaResponseModel uploadFileKendalaResponseModel;
  @override
  List<Object> get props => [uploadFileKendalaResponseModel];
}

class UploadDataError extends UploadDataState {
  const UploadDataError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UploadDataException extends UploadDataState {
  const UploadDataException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
