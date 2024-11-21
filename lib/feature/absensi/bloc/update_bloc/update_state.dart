import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';

abstract class UpdateState extends Equatable {
  const UpdateState();

  @override
  List<Object> get props => [];
}

class UpdateUpdateitial extends UpdateState {}

class UpdateLoading extends UpdateState {}

class UpdateLoaded extends UpdateState {
  const UpdateLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;
  @override
  List<Object> get props => [generalResponseModel];
}

class UpdateError extends UpdateState {
  const UpdateError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UpdateException extends UpdateState {
  const UpdateException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
