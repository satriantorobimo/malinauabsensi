class TunjanganKinerjaListResponseModel {
  String? status;
  String? message;
  List<Data>? data;
  Meta? meta;

  TunjanganKinerjaListResponseModel(
      {this.status, this.message, this.data, this.meta});

  TunjanganKinerjaListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? pegawaiId;
  String? pegawaiNama;
  String? periode;
  String? aktifitas;
  int? tunjanganPokok;
  int? tunjanganTotalRp;
  int? tunjanganTotalPersen;
  List<ListPotongan>? listPotongan;

  Data(
      {this.id,
      this.pegawaiId,
      this.pegawaiNama,
      this.periode,
      this.aktifitas,
      this.tunjanganPokok,
      this.tunjanganTotalRp,
      this.tunjanganTotalPersen,
      this.listPotongan});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pegawaiId = json['pegawai_id'];
    pegawaiNama = json['pegawai_nama'];
    periode = json['periode'];
    aktifitas = json['aktifitas'];
    tunjanganPokok = json['tunjangan_pokok'];
    tunjanganTotalRp = json['tunjangan_total_rp'];
    tunjanganTotalPersen = json['tunjangan_total_persen'];
    if (json['list_potongan'] != null) {
      listPotongan = <ListPotongan>[];
      json['list_potongan'].forEach((v) {
        listPotongan!.add(ListPotongan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pegawai_id'] = pegawaiId;
    data['pegawai_nama'] = pegawaiNama;
    data['periode'] = periode;
    data['aktifitas'] = aktifitas;
    data['tunjangan_pokok'] = tunjanganPokok;
    data['tunjangan_total_rp'] = tunjanganTotalRp;
    data['tunjangan_total_persen'] = tunjanganTotalPersen;
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
  String? reason;

  ListPotongan(
      {this.tipePotongan,
      this.tipePotonganPersen,
      this.potonganRp,
      this.reason});

  ListPotongan.fromJson(Map<String, dynamic> json) {
    tipePotongan = json['tipe_potongan'];
    tipePotonganPersen = json['tipe_potongan_persen'];
    potonganRp = json['potongan_rp'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tipe_potongan'] = tipePotongan;
    data['tipe_potongan_persen'] = tipePotonganPersen;
    data['potongan_rp'] = potonganRp;
    data['reason'] = reason;
    return data;
  }
}

class Meta {
  int? current;
  int? totalPages;
  int? perPage;
  int? totalRecords;

  Meta({this.current, this.totalPages, this.perPage, this.totalRecords});

  Meta.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    totalPages = json['totalPages'];
    perPage = json['perPage'];
    totalRecords = json['totalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current'] = current;
    data['totalPages'] = totalPages;
    data['perPage'] = perPage;
    data['totalRecords'] = totalRecords;
    return data;
  }
}
