import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_response_model.dart';

abstract class OutState extends Equatable {
  const OutState();

  @override
  List<Object> get props => [];
}

class OutOutitial extends OutState {}

class OutLoading extends OutState {}

class OutLoaded extends OutState {
  const OutLoaded({required this.absenResponseModel});
  final AbsenResponseModel absenResponseModel;
  @override
  List<Object> get props => [absenResponseModel];
}

class OutError extends OutState {
  const OutError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class OutException extends OutState {
  const OutException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
