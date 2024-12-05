class AbsenSummaryResponseModel {
  String? status;
  String? message;
  Data? data;

  AbsenSummaryResponseModel({this.status, this.message, this.data});

  AbsenSummaryResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<Summary>? summary;
  int? workingHour;

  Data({this.summary, this.workingHour});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <Summary>[];
      json['summary'].forEach((v) {
        summary!.add(Summary.fromJson(v));
      });
    }
    workingHour = json['working_hour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (summary != null) {
      data['summary'] = summary!.map((v) => v.toJson()).toList();
    }
    data['working_hour'] = workingHour;
    return data;
  }
}

class Summary {
  String? status;
  int? count;

  Summary({this.status, this.count});

  Summary.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['count'] = count;
    return data;
  }
}
