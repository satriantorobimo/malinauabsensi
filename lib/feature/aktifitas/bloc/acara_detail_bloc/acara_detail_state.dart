import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/aktifitas/data/acara_detail_response_model.dart';

abstract class AcaraDetailState extends Equatable {
  const AcaraDetailState();

  @override
  List<Object> get props => [];
}

class AcaraDetailAcaraDetailitial extends AcaraDetailState {}

class AcaraDetailLoading extends AcaraDetailState {}

class AcaraDetailLoaded extends AcaraDetailState {
  const AcaraDetailLoaded({required this.acaraDetailResponseModel});
  final AcaraDetailResponseModel acaraDetailResponseModel;
  @override
  List<Object> get props => [acaraDetailResponseModel];
}

class AcaraDetailError extends AcaraDetailState {
  const AcaraDetailError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AcaraDetailException extends AcaraDetailState {
  const AcaraDetailException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
