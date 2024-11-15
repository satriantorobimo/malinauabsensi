class AbsenDetailResponseModel {
  String? status;
  String? message;
  Data? data;

  AbsenDetailResponseModel({this.status, this.message, this.data});

  AbsenDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  String? checkInTimestamp;
  String? checkOutTimestamp;
  int? workingHourCount;
  String? activity;

  Data(
      {this.name,
      this.createdAt,
      this.checkInTimestamp,
      this.checkOutTimestamp,
      this.workingHourCount,
      this.activity});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    createdAt = json['created_at'];
    checkInTimestamp = json['check_in_timestamp'];
    checkOutTimestamp = json['check_out_timestamp'];
    workingHourCount = json['working_hour_count'];
    activity = json['activity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['created_at'] = createdAt;
    data['check_in_timestamp'] = checkInTimestamp;
    data['check_out_timestamp'] = checkOutTimestamp;
    data['working_hour_count'] = workingHourCount;
    data['activity'] = activity;
    return data;
  }
}
