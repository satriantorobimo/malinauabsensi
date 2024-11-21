class UserAvailabilityResponseModel {
  String? status;
  String? message;
  Data? data;

  UserAvailabilityResponseModel({this.status, this.message, this.data});

  UserAvailabilityResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? attendanceStatus;
  String? userStatus;
  bool? isAvailableToCheckIn;
  bool? isAvailableToCheckOut;
  CheckInRangeTime? checkInRangeTime;
  CheckInRangeTime? checkOutRangeTime;

  Data(
      {this.attendanceStatus,
      this.userStatus,
      this.isAvailableToCheckIn,
      this.isAvailableToCheckOut,
      this.checkInRangeTime,
      this.checkOutRangeTime});

  Data.fromJson(Map<String, dynamic> json) {
    attendanceStatus = json['attendance_status'];
    userStatus = json['user_status'];
    isAvailableToCheckIn = json['is_available_to_check_in'];
    isAvailableToCheckOut = json['is_available_to_check_out'];
    checkInRangeTime = json['check_in_range_time'] != null
        ? CheckInRangeTime.fromJson(json['check_in_range_time'])
        : null;
    checkOutRangeTime = json['check_out_range_time'] != null
        ? CheckInRangeTime.fromJson(json['check_out_range_time'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attendance_status'] = attendanceStatus;
    data['user_status'] = userStatus;
    data['is_available_to_check_in'] = isAvailableToCheckIn;
    data['is_available_to_check_out'] = isAvailableToCheckOut;
    if (checkInRangeTime != null) {
      data['check_in_range_time'] = checkInRangeTime!.toJson();
    }
    if (checkOutRangeTime != null) {
      data['check_out_range_time'] = checkOutRangeTime!.toJson();
    }
    return data;
  }
}

class CheckInRangeTime {
  String? startTime;
  String? endTime;

  CheckInRangeTime({this.startTime, this.endTime});

  CheckInRangeTime.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
