import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_detail_response_model.dart.dart';
import 'package:malinau_absensi/feature/laporan/data/tunjangan_kinerja_list_response_model.dart';
import 'package:malinau_absensi/feature/laporan/domain/tunjangan_kinerja_api.dart';

class TunjanganKinerjaRepo {
  final TunjanganKinerjaApi tunjanganKinerjaApi = TunjanganKinerjaApi();

  Future<TunjanganKinerjaListResponseModel?> attemptListTunjangan() =>
      tunjanganKinerjaApi.attemptListTunjangan();

  Future<TunjanganKinerjaDetailResponseModel?> attemptDetailTunjangan(
          String id) =>
      tunjanganKinerjaApi.attemptDetailTunjangan(id);
}
