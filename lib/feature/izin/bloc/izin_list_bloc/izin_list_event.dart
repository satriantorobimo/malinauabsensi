import 'package:equatable/equatable.dart';

abstract class IzinListEvent extends Equatable {
  const IzinListEvent();
}

class IzinListAttempt extends IzinListEvent {
  const IzinListAttempt({required this.start, required this.end});
  final String start;
  final String end;

  @override
  List<Object> get props => [start, end];
}
