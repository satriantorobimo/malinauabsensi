class LoginResponseModel {
  String? status;
  String? message;
  Data? data;

  LoginResponseModel({this.status, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? token;
  String? tokenType;
  String? expiresIn;
  String? userId;
  String? roleName;
  String? attendanceStatus;
  String? userStatus;
  List<MenuActions>? menuActions;
  String? checkInStartTime;
  String? checkInEndTime;
  String? checkOutStartTime;
  String? checkOutEndTime;

  Data(
      {this.token,
      this.tokenType,
      this.expiresIn,
      this.userId,
      this.roleName,
      this.attendanceStatus,
      this.userStatus,
      this.menuActions,
      this.checkInStartTime,
      this.checkInEndTime,
      this.checkOutStartTime,
      this.checkOutEndTime});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    userId = json['user_id'];
    roleName = json['role_name'];
    attendanceStatus = json['attendance_status'];
    userStatus = json['user_status'];
    if (json['menu_actions'] != null) {
      menuActions = <MenuActions>[];
      json['menu_actions'].forEach((v) {
        menuActions!.add(MenuActions.fromJson(v));
      });
    }
    checkInStartTime = json['check_in_start_time'];
    checkInEndTime = json['check_in_end_time'];
    checkOutStartTime = json['check_out_start_time'];
    checkOutEndTime = json['check_out_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['user_id'] = userId;
    data['role_name'] = roleName;
    data['attendance_status'] = attendanceStatus;
    data['user_status'] = userStatus;
    if (menuActions != null) {
      data['menu_actions'] = menuActions!.map((v) => v.toJson()).toList();
    }
    data['check_in_start_time'] = checkInStartTime;
    data['check_in_end_time'] = checkInEndTime;
    data['check_out_start_time'] = checkOutStartTime;
    data['check_out_end_time'] = checkOutEndTime;
    return data;
  }
}

class MenuActions {
  String? roleID;
  String? menuID;
  String? actionID;
  String? menuURL;
  String? menuName;
  String? groupName;

  MenuActions(
      {this.roleID,
      this.menuID,
      this.actionID,
      this.menuURL,
      this.menuName,
      this.groupName});

  MenuActions.fromJson(Map<String, dynamic> json) {
    roleID = json['RoleID'];
    menuID = json['MenuID'];
    actionID = json['ActionID'];
    menuURL = json['MenuURL'];
    menuName = json['MenuName'];
    groupName = json['GroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RoleID'] = roleID;
    data['MenuID'] = menuID;
    data['ActionID'] = actionID;
    data['MenuURL'] = menuURL;
    data['MenuName'] = menuName;
    data['GroupName'] = groupName;
    return data;
  }
}
