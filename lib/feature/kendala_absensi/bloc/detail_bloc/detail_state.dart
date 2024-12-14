import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/kendala_absen_detail_response_model.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailDetailitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  const DetailLoaded({required this.kendalaAbsenDetailResponseModel});
  final KendalaAbsenDetailResponseModel kendalaAbsenDetailResponseModel;
  @override
  List<Object> get props => [kendalaAbsenDetailResponseModel];
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
