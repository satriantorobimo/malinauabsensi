class IzinListResponseModel {
  String? status;
  String? message;
  List<Data>? data;
  Meta? meta;

  IzinListResponseModel({this.status, this.message, this.data, this.meta});

  IzinListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? fromDate;
  String? toDate;
  String? type;
  String? remarks;
  String? status;
  String? applicantUserId;
  ApplicantUser? applicantUser;
  String? id;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.fromDate,
      this.toDate,
      this.type,
      this.remarks,
      this.status,
      this.applicantUserId,
      this.applicantUser,
      this.id,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    fromDate = json['from_date'];
    toDate = json['to_date'];
    type = json['type'];
    remarks = json['remarks'];
    status = json['status'];
    applicantUserId = json['applicant_user_id'];
    applicantUser = json['applicant_user'] != null
        ? ApplicantUser.fromJson(json['applicant_user'])
        : null;
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['type'] = type;
    data['remarks'] = remarks;
    data['status'] = status;
    data['applicant_user_id'] = applicantUserId;
    if (applicantUser != null) {
      data['applicant_user'] = applicantUser!.toJson();
    }
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ApplicantUser {
  String? id;
  String? name;

  ApplicantUser({this.id, this.name});

  ApplicantUser.fromJson(Map<String, dynamic> json) {
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
