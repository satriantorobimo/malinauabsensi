class UbahPasswordResponseModel {
  String? status;
  String? message;
  UbahPasswordResponseModel? data;

  UbahPasswordResponseModel({this.status, this.message, this.data});

  UbahPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? UbahPasswordResponseModel.fromJson(json['data'])
        : null;
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
  String? nIP;
  String? nIK;
  String? userName;
  String? email;
  String? password;
  DeviceID? deviceID;
  int? isChangedUserDeviceEnabled;
  String? roleID;
  DeviceID? jadwalKhususID;
  String? status;
  String? birthDate;
  String? id;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? updatedBy;

  Data(
      {this.nIP,
        this.nIK,
        this.userName,
        this.email,
        this.password,
        this.deviceID,
        this.isChangedUserDeviceEnabled,
        this.roleID,
        this.jadwalKhususID,
        this.status,
        this.birthDate,
        this.id,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy});

  Data.fromJson(Map<String, dynamic> json) {
    nIP = json['NIP'];
    nIK = json['NIK'];
    userName = json['UserName'];
    email = json['Email'];
    password = json['Password'];
    deviceID = json['DeviceID'] != null
        ? DeviceID.fromJson(json['DeviceID'])
        : null;
    isChangedUserDeviceEnabled = json['IsChangedUserDeviceEnabled'];
    roleID = json['RoleID'];
    jadwalKhususID = json['JadwalKhususID'] != null
        ? DeviceID.fromJson(json['JadwalKhususID'])
        : null;
    status = json['Status'];
    birthDate = json['BirthDate'];
    id = json['id'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NIP'] = nIP;
    data['NIK'] = nIK;
    data['UserName'] = userName;
    data['Email'] = email;
    data['Password'] = password;
    if (deviceID != null) {
      data['DeviceID'] = deviceID!.toJson();
    }
    data['IsChangedUserDeviceEnabled'] = isChangedUserDeviceEnabled;
    data['RoleID'] = roleID;
    if (jadwalKhususID != null) {
      data['JadwalKhususID'] = jadwalKhususID!.toJson();
    }
    data['Status'] = status;
    data['BirthDate'] = birthDate;
    data['id'] = id;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['updated_at'] = updatedAt;
    data['updated_by'] = updatedBy;
    return data;
  }
}

class DeviceID {
  String? string;
  bool? valid;

  DeviceID({this.string, this.valid});

  DeviceID.fromJson(Map<String, dynamic> json) {
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
