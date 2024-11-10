import 'package:equatable/equatable.dart';

abstract class DinasLuarListEvent extends Equatable {
  const DinasLuarListEvent();
}

class DinasLuarListAttempt extends DinasLuarListEvent {
  const DinasLuarListAttempt({required this.page, required this.limit});
  final String page;
  final String limit;

  @override
  List<Object> get props => [page, limit];
}
