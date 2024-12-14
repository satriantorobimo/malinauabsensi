class KendalaAbsenListResponseModel {
  String? status;
  String? message;
  List<Data>? data;
  Meta? meta;

  KendalaAbsenListResponseModel(
      {this.status, this.message, this.data, this.meta});

  KendalaAbsenListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? userNip;
  String? userId;
  String? unitKerja;
  String? unitKerjaId;
  String? unitKerjaInduk;
  String? unitKerjaIndukId;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? supportedFile;
  String? attendanceDate;
  List<String>? actionsToDo;

  Data(
      {this.id,
      this.name,
      this.userNip,
      this.userId,
      this.unitKerja,
      this.unitKerjaId,
      this.unitKerjaInduk,
      this.unitKerjaIndukId,
      this.description,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.supportedFile,
      this.attendanceDate,
      this.actionsToDo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userNip = json['user_nip'];
    userId = json['user_id'];
    unitKerja = json['unit_kerja'];
    unitKerjaId = json['unit_kerja_id'];
    unitKerjaInduk = json['unit_kerja_induk'];
    unitKerjaIndukId = json['unit_kerja_induk_id'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    supportedFile = json['supported_file'];
    attendanceDate = json['attendance_date'];
    actionsToDo = json['actions_to_do'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['user_nip'] = userNip;
    data['user_id'] = userId;
    data['unit_kerja'] = unitKerja;
    data['unit_kerja_id'] = unitKerjaId;
    data['unit_kerja_induk'] = unitKerjaInduk;
    data['unit_kerja_induk_id'] = unitKerjaIndukId;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['supported_file'] = supportedFile;
    data['attendance_date'] = attendanceDate;
    data['actions_to_do'] = actionsToDo;
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
