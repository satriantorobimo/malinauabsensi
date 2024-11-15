import 'package:equatable/equatable.dart';

abstract class DinasLuarListEvent extends Equatable {
  const DinasLuarListEvent();
}

class DinasLuarListAttempt extends DinasLuarListEvent {
  const DinasLuarListAttempt({required this.start, required this.end});
  final String start;
  final String end;

  @override
  List<Object> get props => [start, end];
}
