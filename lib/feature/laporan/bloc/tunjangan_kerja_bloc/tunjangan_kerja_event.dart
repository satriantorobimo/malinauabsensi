import 'package:equatable/equatable.dart';

abstract class TunjanganKerjaEvent extends Equatable {
  const TunjanganKerjaEvent();
}

class TunjanganKerjaListAttempt extends TunjanganKerjaEvent {
  @override
  List<Object> get props => [];
}
