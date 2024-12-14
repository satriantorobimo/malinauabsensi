import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';

abstract class BuatKendalaState extends Equatable {
  const BuatKendalaState();

  @override
  List<Object> get props => [];
}

class BuatKendalaBuatKendalaitial extends BuatKendalaState {}

class BuatKendalaLoading extends BuatKendalaState {}

class DeleteIzinLoading extends BuatKendalaState {}

class BuatKendalaLoaded extends BuatKendalaState {
  const BuatKendalaLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;
  @override
  List<Object> get props => [generalResponseModel];
}

class BuatKendalaError extends BuatKendalaState {
  const BuatKendalaError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class BuatKendalaException extends BuatKendalaState {
  const BuatKendalaException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
