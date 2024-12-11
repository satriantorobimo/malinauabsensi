class TunjanganKinerjaDetailResponseModel {
  int? id;
  String? pegawaiId;
  String? pegawaiNama;
  String? pegawaiNip;
  String? periode;
  String? aktifitas;
  String? predikat;
  List<TipePotongan>? tipePotongan;
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
      this.tipePotongan,
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
    if (json['tipe_potongan'] != null) {
      tipePotongan = <TipePotongan>[];
      json['tipe_potongan'].forEach((v) {
        tipePotongan!.add(new TipePotongan.fromJson(v));
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
    if (tipePotongan != null) {
      data['tipe_potongan'] = tipePotongan!.map((v) => v.toJson()).toList();
    }
    data['tunjangan_pokok'] = tunjanganPokok;
    data['total_potongan'] = totalPotongan;
    data['total_tunjangan'] = totalTunjangan;
    data['total_tunjangan_absensi'] = totalTunjanganAbsensi;
    data['total_tunjangan_kinerja'] = totalTunjanganKinerja;
    return data;
  }
}

class TipePotongan {
  String? tipePotongan;
  int? tipePotonganPersen;
  int? totalPotonganRp;
  var totalPotonganPersen;
  List<ListPotongan>? listPotongan;

  TipePotongan(
      {this.tipePotongan,
      this.tipePotonganPersen,
      this.totalPotonganRp,
      this.totalPotonganPersen,
      this.listPotongan});

  TipePotongan.fromJson(Map<String, dynamic> json) {
    tipePotongan = json['tipe_potongan'];
    tipePotonganPersen = json['tipe_potongan_persen'];
    totalPotonganRp = json['total_potongan_rp'];
    totalPotonganPersen = json['total_potongan_persen'];
    if (json['list_potongan'] != null) {
      listPotongan = <ListPotongan>[];
      json['list_potongan'].forEach((v) {
        listPotongan!.add(new ListPotongan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tipe_potongan'] = tipePotongan;
    data['tipe_potongan_persen'] = tipePotonganPersen;
    data['total_potongan_rp'] = totalPotonganRp;
    data['total_potongan_persen'] = totalPotonganPersen;
    if (listPotongan != null) {
      data['list_potongan'] = listPotongan!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListPotongan {
  String? tipePotongan;
  int? tipePotonganPersen;
  int? potonganRp;
  var potonganPersen;
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
