import 'package:equatable/equatable.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();
}

class UserDetailAttempt extends UserDetailEvent {
  @override
  List<Object> get props => [];
}
