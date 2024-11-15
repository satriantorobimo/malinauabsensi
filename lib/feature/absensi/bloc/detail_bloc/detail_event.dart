import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
}

class DetailAttempt extends DetailEvent {
  const DetailAttempt({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}
