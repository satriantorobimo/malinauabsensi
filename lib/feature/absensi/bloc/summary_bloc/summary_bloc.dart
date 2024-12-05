import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malinau_absensi/feature/absensi/domain/absen_repo.dart';
import 'bloc.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  SummaryState get initialState => SummarySummaryitial();
  AbsenRepo absenRepo = AbsenRepo();
  SummaryBloc({required this.absenRepo}) : super(SummarySummaryitial()) {
    on<SummaryEvent>((event, emit) async {
      if (event is SummaryAttempt) {
        try {
          emit(SummaryLoading());
          final absenSummaryResponseModel =
              await absenRepo.attemptAbsenSummary();
          if (absenSummaryResponseModel!.status == '200') {
            emit(SummaryLoaded(
                absenSummaryResponseModel: absenSummaryResponseModel));
          } else {
            emit(SummaryError(absenSummaryResponseModel.message));
          }
        } catch (e) {
          emit(SummaryException(e.toString()));
        }
      }
    });
  }
}
