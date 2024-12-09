import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/ubah_password/data/ubah_password_response_model.dart';

abstract class UbahPasswordState extends Equatable {
  const UbahPasswordState();

  @override
  List<Object> get props => [];
}

class UbahPasswordUbahPassworditial extends UbahPasswordState {}

class UbahPasswordLoading extends UbahPasswordState {}

class UbahPasswordLoaded extends UbahPasswordState {
  const UbahPasswordLoaded({required this.ubahPasswordResponseModel});

  final UbahPasswordResponseModel ubahPasswordResponseModel;

  @override
  List<Object> get props => [ubahPasswordResponseModel];
}

class UbahPasswordError extends UbahPasswordState {
  const UbahPasswordError(this.error);

  final String? error;

  @override
  List<Object> get props => [error!];
}

class UbahPasswordException extends UbahPasswordState {
  const UbahPasswordException(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
