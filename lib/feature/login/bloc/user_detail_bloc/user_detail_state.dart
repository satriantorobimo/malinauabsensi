import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/login/data/user_detail_response_model.dart';

abstract class UserDetailState extends Equatable {
  const UserDetailState();

  @override
  List<Object> get props => [];
}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  const UserDetailLoaded({required this.userDetailResponseModel});
  final UserDetailResponseModel userDetailResponseModel;

  @override
  List<Object> get props => [userDetailResponseModel];
}

class UserDetailError extends UserDetailState {
  const UserDetailError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class UserDetailException extends UserDetailState {
  const UserDetailException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
