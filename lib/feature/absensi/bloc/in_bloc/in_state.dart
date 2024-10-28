import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_response_model.dart';

abstract class InState extends Equatable {
  const InState();

  @override
  List<Object> get props => [];
}

class InInitial extends InState {}

class InLoading extends InState {}

class InLoaded extends InState {
  const InLoaded({required this.absenResponseModel});
  final AbsenResponseModel absenResponseModel;
  @override
  List<Object> get props => [absenResponseModel];
}

class InError extends InState {
  const InError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class InException extends InState {
  const InException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
