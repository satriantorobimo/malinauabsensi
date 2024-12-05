import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/absensi/data/absen_summary_response_model.dart';

abstract class SummaryState extends Equatable {
  const SummaryState();

  @override
  List<Object> get props => [];
}

class SummarySummaryitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummaryLoaded extends SummaryState {
  const SummaryLoaded({required this.absenSummaryResponseModel});
  final AbsenSummaryResponseModel absenSummaryResponseModel;
  @override
  List<Object> get props => [absenSummaryResponseModel];
}

class SummaryError extends SummaryState {
  const SummaryError(this.error);
  final String? error;

  @override
  List<Object> get props => [error!];
}

class SummaryException extends SummaryState {
  const SummaryException(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
