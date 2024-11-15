import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  static String dateConvert(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yy');
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

  static String dateDayCheck(String data) {
    DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").parse(data);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd');
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
}
