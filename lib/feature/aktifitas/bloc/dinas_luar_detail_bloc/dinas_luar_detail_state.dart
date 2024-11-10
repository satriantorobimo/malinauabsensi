import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_detail_response_model.dart';

abstract class DinasLuarDetailState extends Equatable {
  const DinasLuarDetailState();

  @override
  List<Object> get props => [];
}

class DinasLuarDetailDinasLuarDetailitial extends DinasLuarDetailState {}

class DinasLuarDetailLoading extends DinasLuarDetailState {}

class DinasLuarDetailLoaded extends DinasLuarDetailState {
  const DinasLuarDetailLoaded({required this.dinasLuarDetailResponseModel});
  final DinasLuarDetailResponseModel dinasLuarDetailResponseModel;
  @override
  List<Object> get props => [dinasLuarDetailResponseModel];
}

class DinasLuarDetailError extends DinasLuarDetailState {
  const DinasLuarDetailError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DinasLuarDetailException extends DinasLuarDetailState {
  const DinasLuarDetailException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
