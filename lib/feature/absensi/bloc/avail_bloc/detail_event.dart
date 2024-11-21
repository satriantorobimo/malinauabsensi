import 'package:equatable/equatable.dart';

abstract class AvailEvent extends Equatable {
  const AvailEvent();
}

class AvailAttempt extends AvailEvent {
  @override
  List<Object> get props => [];
}
