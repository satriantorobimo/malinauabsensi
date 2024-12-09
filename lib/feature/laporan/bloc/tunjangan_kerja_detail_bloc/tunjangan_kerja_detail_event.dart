import 'package:equatable/equatable.dart';

abstract class TunjanganKerjaDetailEvent extends Equatable {
  const TunjanganKerjaDetailEvent();
}

class TunjanganKerjaDetailAttempt extends TunjanganKerjaDetailEvent {
  const TunjanganKerjaDetailAttempt({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}
