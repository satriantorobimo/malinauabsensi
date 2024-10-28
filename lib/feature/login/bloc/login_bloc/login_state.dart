import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/login/data/login_response_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  const LoginLoaded({required this.loginResponseModel});
  final LoginResponseModel loginResponseModel;

  @override
  List<Object> get props => [loginResponseModel];
}

class LoginError extends LoginState {
  const LoginError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class LoginException extends LoginState {
  const LoginException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
