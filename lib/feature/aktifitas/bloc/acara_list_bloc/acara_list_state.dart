import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/aktifitas/data/acara_list_response_model.dart';

abstract class AcaraListState extends Equatable {
  const AcaraListState();

  @override
  List<Object> get props => [];
}

class AcaraListAcaraListitial extends AcaraListState {}

class AcaraListLoading extends AcaraListState {}

class AcaraListLoaded extends AcaraListState {
  const AcaraListLoaded({required this.acaraListResponseModel});
  final AcaraListResponseModel acaraListResponseModel;
  @override
  List<Object> get props => [acaraListResponseModel];
}

class AcaraListError extends AcaraListState {
  const AcaraListError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AcaraListException extends AcaraListState {
  const AcaraListException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
