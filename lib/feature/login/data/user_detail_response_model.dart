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
  String? userId;
  String? userNip;
  String? userNik;
  String? userBirthdate;
  String? userName;
  String? userEmail;
  String? roleId;
  String? roleName;
  String? eselonId;
  String? eselonName;
  String? unitKerjaIndukId;
  String? unitKerjaIndukName;
  String? unitKerjaId;
  String? unitKerjaName;

  Data(
      {this.userId,
      this.userNip,
      this.userNik,
      this.userBirthdate,
      this.userName,
      this.userEmail,
      this.roleId,
      this.roleName,
      this.eselonId,
      this.eselonName,
      this.unitKerjaIndukId,
      this.unitKerjaIndukName,
      this.unitKerjaId,
      this.unitKerjaName});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userNip = json['user_nip'];
    userNik = json['user_nik'];
    userBirthdate = json['user_birthdate'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    roleId = json['role_id'];
    roleName = json['role_name'];
    eselonId = json['eselon_id'];
    eselonName = json['eselon_name'];
    unitKerjaIndukId = json['unit_kerja_induk_id'];
    unitKerjaIndukName = json['unit_kerja_induk_name'];
    unitKerjaId = json['unit_kerja_id'];
    unitKerjaName = json['unit_kerja_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_nip'] = userNip;
    data['user_nik'] = userNik;
    data['user_birthdate'] = userBirthdate;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['role_id'] = roleId;
    data['role_name'] = roleName;
    data['eselon_id'] = eselonId;
    data['eselon_name'] = eselonName;
    data['unit_kerja_induk_id'] = unitKerjaIndukId;
    data['unit_kerja_induk_name'] = unitKerjaIndukName;
    data['unit_kerja_id'] = unitKerjaId;
    data['unit_kerja_name'] = unitKerjaName;
    return data;
  }
}
