import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterRegisteritial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {
  const RegisterLoaded({required this.result});
  final String result;
  @override
  List<Object> get props => [result];
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
