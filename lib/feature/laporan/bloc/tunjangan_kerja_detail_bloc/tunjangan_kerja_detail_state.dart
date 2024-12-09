import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_detail_response_model.dart.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_list_response_model.dart'
    as tunj;

abstract class TunjanganKerjaDetailState extends Equatable {
  const TunjanganKerjaDetailState();

  @override
  List<Object> get props => [];
}

class TunjanganKerjaDetailTunjanganKerjaDetailitial
    extends TunjanganKerjaDetailState {}

class TunjanganKerjaDetailLoading extends TunjanganKerjaDetailState {}

class TunjanganKerjaDetailLoaded extends TunjanganKerjaDetailState {
  const TunjanganKerjaDetailLoaded(
      {required this.tunjanganKinerjaDetailResponseModel});

  final TunjanganKinerjaDetailResponseModel tunjanganKinerjaDetailResponseModel;

  @override
  List<Object> get props => [tunjanganKinerjaDetailResponseModel];
}

class TunjanganKerjaDetailError extends TunjanganKerjaDetailState {
  const TunjanganKerjaDetailError(this.error);

  final String? error;

  @override
  List<Object> get props => [error!];
}

class TunjanganKerjaDetailException extends TunjanganKerjaDetailState {
  const TunjanganKerjaDetailException(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
