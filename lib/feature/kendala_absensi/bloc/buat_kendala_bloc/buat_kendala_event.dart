import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/izin/data/tambah_izin_request_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/buat_kendala_absen_request_model.dart';

abstract class BuatKendalaEvent extends Equatable {
  const BuatKendalaEvent();
}

class BuatKendalaAttempt extends BuatKendalaEvent {
  const BuatKendalaAttempt({required this.buatKendalaAbsenRequestModel});
  final BuatKendalaAbsenRequestModel buatKendalaAbsenRequestModel;

  @override
  List<Object> get props => [buatKendalaAbsenRequestModel];
}
