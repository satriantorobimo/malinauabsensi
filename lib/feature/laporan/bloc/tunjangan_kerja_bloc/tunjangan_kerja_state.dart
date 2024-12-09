import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_detail_response_model.dart.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_list_response_model.dart'
    as tunj;

abstract class TunjanganKerjaState extends Equatable {
  const TunjanganKerjaState();

  @override
  List<Object> get props => [];
}

class TunjanganKerjaTunjanganKerjaitial extends TunjanganKerjaState {}

class TunjanganKerjaLoading extends TunjanganKerjaState {}

class TunjanganKerjaListLoaded extends TunjanganKerjaState {
  const TunjanganKerjaListLoaded(
      {required this.tunjanganKinerjaListResponseModel});

  final List<tunj.Data> tunjanganKinerjaListResponseModel;

  @override
  List<Object> get props => [tunjanganKinerjaListResponseModel];
}

class TunjanganKerjaError extends TunjanganKerjaState {
  const TunjanganKerjaError(this.error);

  final String? error;

  @override
  List<Object> get props => [error!];
}

class TunjanganKerjaException extends TunjanganKerjaState {
  const TunjanganKerjaException(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
