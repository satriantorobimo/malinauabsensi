import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/upload_file_izin_request_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/buat_kendala_absen_request_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/kendala_absen_detail_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/kendala_absen_list_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/upload_file_kendala_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/domain/kendala_absen_api.dart';

class KendalaAbsenRepo {
  final KendalaAbsenApi kendalaAbsenApi = KendalaAbsenApi();

  Future<KendalaAbsenListResponseModel?> attemptKedanalaAbsenList(
          String start, String end) =>
      kendalaAbsenApi.attemptKedanalaAbsenList(start, end);

  Future<KendalaAbsenDetailResponseModel?> attemptKendalaAbsenDetail(
          String id) =>
      kendalaAbsenApi.attemptKendalaAbsenDetail(id);

  Future<GeneralResponseModel?> attemptBuatKendalaAbsen(
          BuatKendalaAbsenRequestModel data) =>
      kendalaAbsenApi.attemptBuatKendalaAbsen(data);

  Future<UploadFileKendalaResponseModel?> attemptUploadFileKendala(
          UploadFileIzinRequestModel uploadFileIzinRequestModel) =>
      kendalaAbsenApi.attemptUploadFileKendala(uploadFileIzinRequestModel);
}
