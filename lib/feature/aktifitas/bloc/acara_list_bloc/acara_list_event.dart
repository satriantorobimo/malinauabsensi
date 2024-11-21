import 'package:equatable/equatable.dart';

abstract class AcaraListEvent extends Equatable {
  const AcaraListEvent();
}

class AcaraListAttempt extends AcaraListEvent {
  const AcaraListAttempt({required this.start, required this.end});
  final String start;
  final String end;

  @override
  List<Object> get props => [start, end];
}
