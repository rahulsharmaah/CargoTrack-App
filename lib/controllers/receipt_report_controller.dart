import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/model/rpclass.dart';
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class ReceiptReportController extends GetxController {
  var searchController = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  DateTime fromDate = DateTime.now(); // Provide default values here
  DateTime toDate = DateTime.now();
  List<RecUser> receiptData = [];
  List<RecUser> originalData = [];
  List<RecUser> lastfiveDayReceipt = [];
  double totalSum = 0.0;
  double lastFiveDaySum = 0.0;

  Future<void> getReceiptDetails() async {
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);

      var res = await http.post(
        Uri.parse(API.recRepDisplay),
        body: {
          'fromDate': formattedFromDate,
          'toDate': formattedToDate,
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );
      if (res.statusCode == 200) {
        print(res.body);
        var responseBodyOfReceiptReport = jsonDecode(res.body);
        if (responseBodyOfReceiptReport["success"] == true) {
          List<RecUser> data =
              (responseBodyOfReceiptReport["receiptReportData"] as List)
                  .map((eachRecord) {
            return RecUser.fromJson(eachRecord);
          }).toList();

          receiptData = data;
          originalData = data; // Store the original data
          calculateTotalSum(); // Calculate the total sum
          getLastfiveDayReceipt();
          update();
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }
  }

  void calculateTotalSum() {
    totalSum = receiptData.fold(
        0.0, (sum, item) => sum + double.parse(item.receipt_amount));
    print("total sum : $totalSum");
    // Automatically navigate to OtherScreen and pass totalSum
    //Get.to(HomeFragmentScreen(totalAmount: totalSum));
  }

  void getLastfiveDayReceipt() {
    final today = DateTime.now();

    final last5DaysDate = today.subtract(const Duration(days: 5));

    receiptData
        .where((payment) => DateFormat("yyyy-MM-dd")
            .parse(payment.receipt_date)
            .isAfter(last5DaysDate))
        .toList()
        .forEach((element) {
      if (!lastfiveDayReceipt
          .any((po) => po.receipt_id == element.receipt_id)) {
        lastfiveDayReceipt.add(element);
      }
    });

    lastFiveDaySum = lastfiveDayReceipt.fold(
        0.0, (sum, item) => sum + double.parse(item.receipt_amount));
    update();
  }

  void filterData(
      String searchText, DateTime selectedFromDate, DateTime selectedToDate) {
    receiptData = originalData.where((item) {
      final receiptDate = DateFormat("yyyy-MM-dd").parse(item.receipt_date);
      final searchQuery = searchText.toLowerCase();

      bool isWithinDateRange = receiptDate.isAtSameMomentAs(selectedFromDate) ||
          receiptDate.isAtSameMomentAs(selectedToDate) ||
          (receiptDate.isAfter(selectedFromDate) &&
              receiptDate.isBefore(selectedToDate));

      return isWithinDateRange &&
          (item.receipt_customer.toLowerCase().contains(searchQuery) ||
              item.receipt_id.toString().contains(searchQuery) ||
              item.receipt_amount.toLowerCase().contains(searchQuery) ||
              item.receipt_cb.toLowerCase().contains(searchQuery) ||
              item.receipt_ledger.toLowerCase().contains(searchQuery) ||
              item.receipt_date.toLowerCase().contains(searchQuery));
    }).toList();
    update();
  }
}
