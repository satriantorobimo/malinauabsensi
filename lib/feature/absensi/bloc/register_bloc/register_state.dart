import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterRegisteritial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {
  const RegisterLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;
  @override
  List<Object> get props => [generalResponseModel];
}

class RegisterError extends RegisterState {
  const RegisterError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class RegisterException extends RegisterState {
  const RegisterException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
