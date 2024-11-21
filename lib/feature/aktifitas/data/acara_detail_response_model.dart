class AcaraDetailResponseModel {
  String? status;
  String? message;
  Data? data;

  AcaraDetailResponseModel({this.status, this.message, this.data});

  AcaraDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? kind;
  String? name;
  String? description;
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
      this.description,
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
    description = json['description'];
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
    data['description'] = description;
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
