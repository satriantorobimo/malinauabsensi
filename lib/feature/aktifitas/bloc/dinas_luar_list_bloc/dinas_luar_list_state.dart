import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_list_response_model.dart';

abstract class DinasLuarListState extends Equatable {
  const DinasLuarListState();

  @override
  List<Object> get props => [];
}

class DinasLuarListDinasLuarListitial extends DinasLuarListState {}

class DinasLuarListLoading extends DinasLuarListState {}

class DinasLuarListLoaded extends DinasLuarListState {
  const DinasLuarListLoaded({required this.dinasLuarListResponseModel});
  final DinasLuarListResponseModel dinasLuarListResponseModel;
  @override
  List<Object> get props => [dinasLuarListResponseModel];
}

class DinasLuarListError extends DinasLuarListState {
  const DinasLuarListError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class DinasLuarListException extends DinasLuarListState {
  const DinasLuarListException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
