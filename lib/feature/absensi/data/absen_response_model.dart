class AbsenResponseModel {
  String? status;
  String? message;
  Data? data;

  AbsenResponseModel({this.status, this.message, this.data});

  AbsenResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? requestType;
  String? userId;
  String? timestamp;

  Data({this.requestType, this.userId, this.timestamp});

  Data.fromJson(Map<String, dynamic> json) {
    requestType = json['request_type'];
    userId = json['user_id'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_type'] = requestType;
    data['user_id'] = userId;
    data['timestamp'] = timestamp;
    return data;
  }
}
