import 'package:equatable/equatable.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();
}

class KendalaListAttempt extends ListEvent {
  const KendalaListAttempt({required this.start, required this.end});
  final String start;
  final String end;
  @override
  List<Object> get props => [start, end];
}
