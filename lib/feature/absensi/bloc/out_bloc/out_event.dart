import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_out_request_model.dart';

abstract class OutEvent extends Equatable {
  const OutEvent();
}

class OutAttempt extends OutEvent {
  const OutAttempt({required this.absenOutRequestModel});
  final AbsenOutRequestModel absenOutRequestModel;

  @override
  List<Object> get props => [absenOutRequestModel];
}
