import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/user_availability_response_model.dart';

abstract class AvailState extends Equatable {
  const AvailState();

  @override
  List<Object> get props => [];
}

class AvailAvailitial extends AvailState {}

class AvailLoading extends AvailState {}

class AvailLoaded extends AvailState {
  const AvailLoaded({required this.userAvailabilityResponseModel});
  final UserAvailabilityResponseModel userAvailabilityResponseModel;
  @override
  List<Object> get props => [userAvailabilityResponseModel];
}

class AvailError extends AvailState {
  const AvailError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class AvailException extends AvailState {
  const AvailException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
