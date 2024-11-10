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
  String? status;
  List<MenuActions>? menuActions;

  Data(
      {this.token,
      this.tokenType,
      this.expiresIn,
      this.userId,
      this.status,
      this.menuActions});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    userId = json['user_id'];
    status = json['status'];
    if (json['menu_actions'] != null) {
      menuActions = <MenuActions>[];
      json['menu_actions'].forEach((v) {
        menuActions!.add(MenuActions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['user_id'] = userId;
    data['status'] = status;
    if (menuActions != null) {
      data['menu_actions'] = menuActions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuActions {
  String? roleID;
  String? menuID;
  String? actionID;

  MenuActions({this.roleID, this.menuID, this.actionID});

  MenuActions.fromJson(Map<String, dynamic> json) {
    roleID = json['RoleID'];
    menuID = json['MenuID'];
    actionID = json['ActionID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RoleID'] = roleID;
    data['MenuID'] = menuID;
    data['ActionID'] = actionID;
    return data;
  }
}
