class UserDetailResponseModel {
  String? status;
  String? message;
  Data? data;

  UserDetailResponseModel({this.status, this.message, this.data});

  UserDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? userID;
  String? email;
  String? nip;
  String? nik;
  String? name;
  String? birthdate;
  String? eselon;
  String? opd;
  String? unitKerja;
  String? role;
  String? roleID;
  String? eselonID;
  String? unitKerjaIndukID;
  String? unitkerjaID;
  String? seksi;

  Data(
      {this.userID,
      this.email,
      this.nip,
      this.nik,
      this.name,
      this.birthdate,
      this.eselon,
      this.opd,
      this.unitKerja,
      this.role,
      this.roleID,
      this.eselonID,
      this.unitKerjaIndukID,
      this.unitkerjaID,
      this.seksi});

  Data.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    email = json['email'];
    nip = json['nip'];
    nik = json['nik'];
    name = json['name'];
    birthdate = json['birthdate'];
    eselon = json['eselon'];
    opd = json['opd'];
    unitKerja = json['unitKerja'];
    role = json['role'];
    roleID = json['roleID'];
    eselonID = json['eselonID'];
    unitKerjaIndukID = json['unitKerjaIndukID'];
    unitkerjaID = json['unitkerjaID'];
    seksi = json['seksi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['email'] = email;
    data['nip'] = nip;
    data['nik'] = nik;
    data['name'] = name;
    data['birthdate'] = birthdate;
    data['eselon'] = eselon;
    data['opd'] = opd;
    data['unitKerja'] = unitKerja;
    data['role'] = role;
    data['roleID'] = roleID;
    data['eselonID'] = eselonID;
    data['unitKerjaIndukID'] = unitKerjaIndukID;
    data['unitkerjaID'] = unitkerjaID;
    data['seksi'] = seksi;
    return data;
  }
}
