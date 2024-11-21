class AcaraListResponseModel {
  String? status;
  String? message;
  List<Data>? data;
  Meta? meta;

  AcaraListResponseModel({this.status, this.message, this.data, this.meta});

  AcaraListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? kind;
  String? name;
  String? address;
  Location? location;
  int? day;
  bool? status;
  String? startTime;
  String? endTime;
  String? id;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.kind,
      this.name,
      this.address,
      this.location,
      this.day,
      this.status,
      this.startTime,
      this.endTime,
      this.id,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    name = json['name'];
    address = json['address'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    day = json['day'];
    status = json['status'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kind'] = kind;
    data['name'] = name;
    data['address'] = address;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['day'] = day;
    data['status'] = status;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
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
