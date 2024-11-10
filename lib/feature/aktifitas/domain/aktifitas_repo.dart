import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_detail_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/data/dinas_luar_list_response_model.dart';
import 'package:malinau_absensi/feature/aktifitas/domain/aktifitas_api.dart';

class AktifitasARepo {
  final AktifitasApi aktifitasApi = AktifitasApi();

  Future<DinasLuarListResponseModel?> attemptDinasLuarList(
          String page, String limit) =>
      aktifitasApi.attemptDinasLuarList(page, limit);

  Future<DinasLuarDetailResponseModel?> attemptDinasLuarDetail(String id) =>
      aktifitasApi.attemptDinasLuarDetail(id);
}
