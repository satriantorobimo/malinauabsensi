import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:malinau_absensi/feature/login/data/login_response_model.dart';
import 'package:malinau_absensi/util/shared_pref_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class GeneralUtil {
  void showSnackBarError(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBarSuccess(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackBarWarning(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String dateConvert(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String timeConvert(String data) {
    DateTime parseDate = DateFormat("HH:mm:ss").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('HH:mm');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String dateConvertDetail(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('EEEE, dd MMMM yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String dayConv(String data) {
    var hari = "";

    switch (data) {
      case '1':
        {
          hari = "Minggu";
        }
        break;
      case '2':
        {
          hari = "Senin";
        }
        break;
      case '3':
        {
          hari = "Selasa";
        }
        break;
      case '4':
        {
          hari = "Rabu";
        }
        break;
      case '5':
        {
          hari = "Kamis";
        }
        break;
      case '6':
        {
          hari = "Jumat";
        }
        break;
      case '7':
        {
          hari = "Sabtu";
        }
        break;
    }

    return hari;
  }

  static String dayCheck(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('EEEE');
    var outputDate = outputFormat.format(inputDate);

    var hari = "";
    switch (outputDate) {
      case 'Sunday':
        {
          hari = "Minggu";
        }
        break;
      case 'Monday':
        {
          hari = "Senin";
        }
        break;
      case 'Tuesday':
        {
          hari = "Selasa";
        }
        break;
      case 'Wednesday':
        {
          hari = "Rabu";
        }
        break;
      case 'Thursday':
        {
          hari = "Kamis";
        }
        break;
      case 'Friday':
        {
          hari = "Jumat";
        }
        break;
      case 'Saturday':
        {
          hari = "Sabtu";
        }
        break;
    }

    return hari;
  }

  static double fontSize(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // Define font size based on screen width
    return screenHeight * 0.05;
  }

  static String dateDayCheck(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String convertDate(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String convertDateSend(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String monthCheck(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MM');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  static String monthCheck2(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MMM');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  bool isWithinCheckInTime(String checkInStartTime) {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Parse check_in_start_time into a DateTime object
    DateTime checkInStart = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(checkInStartTime.split(":")[0]),
      int.parse(checkInStartTime.split(":")[1]),
      int.parse(checkInStartTime.split(":")[2]),
    );

    // Check if the current time is within the start and end times
    return now.isAfter(checkInStart);
  }

  Map<String, String> getFormattedFirstAndLastDateOfLastSevenDays() {
    DateTime now = DateTime.now();
    DateTime firstDate = now.subtract(const Duration(days: 6));
    DateTime lastDate = now;
    String formattedFirstDate = DateFormat('yyyy-MM-dd').format(firstDate);
    String formattedLastDate = DateFormat('yyyy-MM-dd').format(lastDate);
    return {
      'firstDate': formattedFirstDate,
      'lastDate': formattedLastDate,
    };
  }

  Future<Map<String, String>> getDataUser() async {
    final String? name = await SharedPrefUtil.getSharedString('nama');
    final String? role = await SharedPrefUtil.getSharedString('role');
    return {
      'name': name!,
      'role': role!,
    };
  }

  Future<void> saveMenuActionsToSharedPreferences(
      List<MenuActions> menuActions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the list of MenuActions to JSON string
    String jsonString =
        jsonEncode(menuActions.map((action) => action.toJson()).toList());

    // Store the JSON string
    await prefs.setString('menu_actions', jsonString);
  }

  Future<List<MenuActions>> getMenuActionsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string
    String? jsonString = prefs.getString('menu_actions');

    if (jsonString != null) {
      // Decode the JSON string and map it to a list of MenuActions
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => MenuActions.fromJson(json)).toList();
    }

    return [];
  }

  Map<String, String> getFormattedFirstAndLastDateOfLast3Days() {
    DateTime now = DateTime.now();
    DateTime firstDate = now.subtract(const Duration(days: 3));
    DateTime lastDate = now;
    String formattedFirstDate = DateFormat('yyyy-MM-dd').format(firstDate);
    String formattedLastDate = DateFormat('yyyy-MM-dd').format(lastDate);
    return {
      'firstDate': formattedFirstDate,
      'lastDate': formattedLastDate,
    };
  }

  Map<String, String> getFormattedFirstAndLastDateOfCurrentMonth() {
    DateTime now = DateTime.now();

    // First and last date
    DateTime firstDate = DateTime(now.year, now.month, 1);
    DateTime lastDate = DateTime(now.year, now.month + 1, 0);

    // Format dates
    String formattedFirstDate = DateFormat('yyyy-MM-dd').format(firstDate);
    String formattedLastDate = DateFormat('yyyy-MM-dd').format(lastDate);

    return {
      'firstDate': formattedFirstDate,
      'lastDate': formattedLastDate,
    };
  }

  Map<String, String> getFormattedFirstAndLastDateOfLastThreeMonths() {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year, now.month - 2, 1);
    DateTime lastDate = DateTime(now.year, now.month + 1, 0);
    String formattedFirstDate = DateFormat('yyyy-MM-dd').format(firstDate);
    String formattedLastDate = DateFormat('yyyy-MM-dd').format(lastDate);
    return {
      'firstDate': formattedFirstDate,
      'lastDate': formattedLastDate,
    };
  }

  Widget loading3Data(int data) {
    return ListView.separated(
        itemCount: data,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade300,
              ),
              height: 50,
              width: double.infinity,
            ),
          );
        });
  }

  Widget loadingRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.25,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.25,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade300,
            ),
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.25,
          ),
        )
      ],
    );
  }
}
