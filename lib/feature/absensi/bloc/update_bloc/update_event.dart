import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/update_absen_request_model.dart';

abstract class UpdateEvent extends Equatable {
  const UpdateEvent();
}

class UpdateAttempt extends UpdateEvent {
  const UpdateAttempt({required this.updateAbsenRequestModel});
  final UpdateAbsenRequestModel updateAbsenRequestModel;

  @override
  List<Object> get props => [updateAbsenRequestModel];
}
