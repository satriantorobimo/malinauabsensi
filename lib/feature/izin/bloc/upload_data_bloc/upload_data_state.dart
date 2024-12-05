import 'package:equatable/equatable.dart';

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
