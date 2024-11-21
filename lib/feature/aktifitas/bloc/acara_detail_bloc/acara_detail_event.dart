import 'package:equatable/equatable.dart';

abstract class AcaraDetailEvent extends Equatable {
  const AcaraDetailEvent();
}

class AcaraDetailAttempt extends AcaraDetailEvent {
  const AcaraDetailAttempt({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}
