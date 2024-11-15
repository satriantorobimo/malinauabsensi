import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_detail_response_model.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailDetailitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  const DetailLoaded({required this.absenDetailResponseModel});
  final AbsenDetailResponseModel absenDetailResponseModel;
  @override
  List<Object> get props => [absenDetailResponseModel];
}

class DetailError extends DetailState {
  const DetailError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DetailException extends DetailState {
  const DetailException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
