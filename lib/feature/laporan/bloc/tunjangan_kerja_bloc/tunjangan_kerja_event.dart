import 'package:equatable/equatable.dart';

abstract class TunjanganKerjaEvent extends Equatable {
  const TunjanganKerjaEvent();
}

class TunjanganKerjaListAttempt extends TunjanganKerjaEvent {
  const TunjanganKerjaListAttempt({required this.start, required this.end});
  final String start;
  final String end;

  @override
  List<Object> get props => [start, end];
}
