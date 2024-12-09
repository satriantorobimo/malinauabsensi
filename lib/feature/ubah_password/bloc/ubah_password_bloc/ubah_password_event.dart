import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/ubah_password/data/ubah_password_request_model.dart';

abstract class UbahPasswordEvent extends Equatable {
  const UbahPasswordEvent();
}

class UbahPasswordAttempt extends UbahPasswordEvent {
  const UbahPasswordAttempt({required this.ubahPasswordRequestModel});
  final UbahPasswordRequestModel ubahPasswordRequestModel;

  @override
  List<Object> get props => [ubahPasswordRequestModel];
}
