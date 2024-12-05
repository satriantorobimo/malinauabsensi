import 'package:equatable/equatable.dart';
import 'package:malinau_absensi/feature/izin/data/tambah_izin_request_model.dart';

abstract class TambahIzinEvent extends Equatable {
  const TambahIzinEvent();
}

class TambahIzinAttempt extends TambahIzinEvent {
  const TambahIzinAttempt({required this.tambahIzinRequestModel});
  final TambahIzinRequestModel tambahIzinRequestModel;

  @override
  List<Object> get props => [tambahIzinRequestModel];
}

class EditIzinAttempt extends TambahIzinEvent {
  const EditIzinAttempt({required this.tambahIzinRequestModel});
  final TambahIzinRequestModel tambahIzinRequestModel;

  @override
  List<Object> get props => [tambahIzinRequestModel];
}

class DeleteIzinAttempt extends TambahIzinEvent {
  const DeleteIzinAttempt({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}
