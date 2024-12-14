import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
}

class KendalaDetailAttempt extends DetailEvent {
  const KendalaDetailAttempt({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}
