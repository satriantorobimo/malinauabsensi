class DinasLuarDetailResponseModel {
  String? status;
  String? message;
  Data? data;

  DinasLuarDetailResponseModel({this.status, this.message, this.data});

  DinasLuarDetailResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? description;
  String? address;
  Location? location;
  String? statusPengajuan;
  String? startDate;
  String? endDate;
  String? fileName;
  UnitKerjaInduk? unitKerjaInduk;
  String? id;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.name,
      this.description,
      this.address,
      this.location,
      this.statusPengajuan,
      this.startDate,
      this.endDate,
      this.fileName,
      this.unitKerjaInduk,
      this.id,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    address = json['address'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    statusPengajuan = json['status_pengajuan'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    fileName = json['file_name'];
    unitKerjaInduk = json['unit_kerja_induk'] != null
        ? UnitKerjaInduk.fromJson(json['unit_kerja_induk'])
        : null;
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['address'] = address;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['status_pengajuan'] = statusPengajuan;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['file_name'] = fileName;
    if (unitKerjaInduk != null) {
      data['unit_kerja_induk'] = unitKerjaInduk!.toJson();
    }
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Location {
  double? lat;
  double? long;

  Location({this.lat, this.long});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

class UnitKerjaInduk {
  String? id;
  String? name;

  UnitKerjaInduk({this.id, this.name});

  UnitKerjaInduk.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
