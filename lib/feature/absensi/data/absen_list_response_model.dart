class AbsenListResponseModel {
  String? status;
  String? message;
  List<Data>? data;
  Meta? meta;

  AbsenListResponseModel({this.status, this.message, this.data, this.meta});

  AbsenListResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? userID;
  Location? location;
  String? image;
  String? status;
  String? activity;
  CheckInTime? checkInTime;
  CheckInTime? checkOutTime;
  String? id;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.userID,
      this.location,
      this.image,
      this.status,
      this.activity,
      this.checkInTime,
      this.checkOutTime,
      this.id,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    image = json['Image'];
    status = json['Status'];
    activity = json['Activity'];
    checkInTime = json['CheckInTime'] != null
        ? CheckInTime.fromJson(json['CheckInTime'])
        : null;
    checkOutTime = json['CheckOutTime'] != null
        ? CheckInTime.fromJson(json['CheckOutTime'])
        : null;
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userID;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['Image'] = image;
    data['Status'] = status;
    data['Activity'] = activity;
    if (checkInTime != null) {
      data['CheckInTime'] = checkInTime!.toJson();
    }
    if (checkOutTime != null) {
      data['CheckOutTime'] = checkOutTime!.toJson();
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

class CheckInTime {
  String? string;
  bool? valid;

  CheckInTime({this.string, this.valid});

  CheckInTime.fromJson(Map<String, dynamic> json) {
    string = json['String'];
    valid = json['Valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['String'] = string;
    data['Valid'] = valid;
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
