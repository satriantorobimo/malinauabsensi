class TunjanganKinerjaDetailResponseModel {
  int? id;
  String? pegawaiId;
  String? pegawaiNama;
  String? pegawaiNip;
  String? periode;
  String? aktifitas;
  String? predikat;
  List<ListPotongan>? listPotongan;
  int? tunjanganPokok;
  int? totalPotongan;
  int? totalTunjangan;
  int? totalTunjanganAbsensi;
  int? totalTunjanganKinerja;

  TunjanganKinerjaDetailResponseModel(
      {this.id,
      this.pegawaiId,
      this.pegawaiNama,
      this.pegawaiNip,
      this.periode,
      this.aktifitas,
      this.predikat,
      this.listPotongan,
      this.tunjanganPokok,
      this.totalPotongan,
      this.totalTunjangan,
      this.totalTunjanganAbsensi,
      this.totalTunjanganKinerja});

  TunjanganKinerjaDetailResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pegawaiId = json['pegawai_id'];
    pegawaiNama = json['pegawai_nama'];
    pegawaiNip = json['pegawai_nip'];
    periode = json['periode'];
    aktifitas = json['aktifitas'];
    predikat = json['predikat'];
    if (json['list_potongan'] != null) {
      listPotongan = <ListPotongan>[];
      json['list_potongan'].forEach((v) {
        listPotongan!.add(ListPotongan.fromJson(v));
      });
    }
    tunjanganPokok = json['tunjangan_pokok'];
    totalPotongan = json['total_potongan'];
    totalTunjangan = json['total_tunjangan'];
    totalTunjanganAbsensi = json['total_tunjangan_absensi'];
    totalTunjanganKinerja = json['total_tunjangan_kinerja'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pegawai_id'] = pegawaiId;
    data['pegawai_nama'] = pegawaiNama;
    data['pegawai_nip'] = pegawaiNip;
    data['periode'] = periode;
    data['aktifitas'] = aktifitas;
    data['predikat'] = predikat;
    if (listPotongan != null) {
      data['list_potongan'] = listPotongan!.map((v) => v.toJson()).toList();
    }
    data['tunjangan_pokok'] = tunjanganPokok;
    data['total_potongan'] = totalPotongan;
    data['total_tunjangan'] = totalTunjangan;
    data['total_tunjangan_absensi'] = totalTunjanganAbsensi;
    data['total_tunjangan_kinerja'] = totalTunjanganKinerja;
    return data;
  }
}

class ListPotongan {
  String? tipePotongan;
  int? tipePotonganPersen;
  int? potonganRp;
  int? potonganPersen;
  String? reason;

  ListPotongan(
      {this.tipePotongan,
      this.tipePotonganPersen,
      this.potonganRp,
      this.potonganPersen,
      this.reason});

  ListPotongan.fromJson(Map<String, dynamic> json) {
    tipePotongan = json['tipe_potongan'];
    tipePotonganPersen = json['tipe_potongan_persen'];
    potonganRp = json['potongan_rp'];
    potonganPersen = json['potongan_persen'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tipe_potongan'] = tipePotongan;
    data['tipe_potongan_persen'] = tipePotonganPersen;
    data['potongan_rp'] = potonganRp;
    data['potongan_persen'] = potonganPersen;
    data['reason'] = reason;
    return data;
  }
}
