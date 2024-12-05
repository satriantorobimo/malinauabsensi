import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';

abstract class TambahIzinState extends Equatable {
  const TambahIzinState();

  @override
  List<Object> get props => [];
}

class TambahIzinTambahIzinitial extends TambahIzinState {}

class TambahIzinLoading extends TambahIzinState {}

class DeleteIzinLoading extends TambahIzinState {}

class TambahIzinLoaded extends TambahIzinState {
  const TambahIzinLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;
  @override
  List<Object> get props => [generalResponseModel];
}

class EditIzinLoaded extends TambahIzinState {
  const EditIzinLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;
  @override
  List<Object> get props => [generalResponseModel];
}

class DeleteIzinLoaded extends TambahIzinState {
  const DeleteIzinLoaded({required this.generalResponseModel});
  final GeneralResponseModel generalResponseModel;
  @override
  List<Object> get props => [generalResponseModel];
}

class TambahIzinError extends TambahIzinState {
  const TambahIzinError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class TambahIzinException extends TambahIzinState {
  const TambahIzinException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
