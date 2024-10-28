import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_request_model.dart';

abstract class InEvent extends Equatable {
  const InEvent();
}

class InAttempt extends InEvent {
  const InAttempt({required this.absenRequestModel});
  final AbsenRequestModel absenRequestModel;

  @override
  List<Object> get props => [absenRequestModel];
}
