import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  const SummaryEvent();
}

class SummaryAttempt extends SummaryEvent {
  @override
  List<Object> get props => [];
}
