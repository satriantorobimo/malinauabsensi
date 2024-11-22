import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/izin/data/izin_list_response_model.dart';

abstract class IzinListState extends Equatable {
  const IzinListState();

  @override
  List<Object> get props => [];
}

class IzinListIzinListitial extends IzinListState {}

class IzinListLoading extends IzinListState {}

class IzinListLoaded extends IzinListState {
  const IzinListLoaded({required this.izinListResponseModel});
  final IzinListResponseModel izinListResponseModel;
  @override
  List<Object> get props => [izinListResponseModel];
}

class IzinListError extends IzinListState {
  const IzinListError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class IzinListException extends IzinListState {
  const IzinListException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
