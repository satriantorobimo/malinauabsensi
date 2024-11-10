import 'package:equatable/equatable.dart';

abstract class DinasLuarDetailEvent extends Equatable {
  const DinasLuarDetailEvent();
}

class DinasLuarDetailAttempt extends DinasLuarDetailEvent {
  const DinasLuarDetailAttempt({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}
