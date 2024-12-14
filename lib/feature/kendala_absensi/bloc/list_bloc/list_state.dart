import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_list_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/kendala_absen_list_response_model.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListListitial extends ListState {}

class ListLoading extends ListState {}

class ListLoaded extends ListState {
  const ListLoaded({required this.kendalaAbsenListResponseModel});
  final KendalaAbsenListResponseModel kendalaAbsenListResponseModel;
  @override
  List<Object> get props => [kendalaAbsenListResponseModel];
}

class ListError extends ListState {
  const ListError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class ListException extends ListState {
  const ListException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
