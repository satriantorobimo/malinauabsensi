import 'package:malinau_absensi/feature/absensi/data/general_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/izin_list_response_model.dart';
import 'package:malinau_absensi/feature/izin/data/tambah_izin_request_model.dart';
import 'package:malinau_absensi/feature/izin/data/upload_file_izin_request_model.dart';
import 'package:malinau_absensi/feature/izin/domain/izin_api.dart';
import 'package:malinau_absensi/feature/kendala_absensi/data/upload_file_kendala_response_model.dart';
import 'package:malinau_absensi/feature/kendala_absensi/domain/kendala_absen_api.dart';

class IzinRepo {
  final IzinApi izinApi = IzinApi();
  final KendalaAbsenApi kendalaAbsenApi = KendalaAbsenApi();

  Future<IzinListResponseModel?> attemptIzinList(String page, String limit) =>
      izinApi.attemptIzinList(page, limit);

  Future<GeneralResponseModel?> attemptTambahIzin(
          TambahIzinRequestModel tambahIzinRequestModel) =>
      izinApi.attemptTambahIzin(tambahIzinRequestModel);

  Future<GeneralResponseModel?> attemptEditIzin(
          TambahIzinRequestModel tambahIzinRequestModel) =>
      izinApi.attemptEditIzin(tambahIzinRequestModel);

  Future<GeneralResponseModel?> attemptDeleteIzin(String id) =>
      izinApi.attemptDeleteIzin(id);

  Future<String?> attemptUploadFile(
          UploadFileIzinRequestModel uploadIzinRequestModel) =>
      izinApi.attemptUploadFile(uploadIzinRequestModel);

  Future<UploadFileKendalaResponseModel?> attemptUploadFileKendala(
          UploadFileIzinRequestModel uploadFileIzinRequestModel) =>
      kendalaAbsenApi.attemptUploadFileKendala(uploadFileIzinRequestModel);
}
