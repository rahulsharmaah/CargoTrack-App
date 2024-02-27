import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:trans_port/model/paymasclass.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class PaymentReportController extends GetxController {
  var searchController = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  DateTime fromDate = DateTime.now(); // Provide default values here
  DateTime toDate = DateTime.now();
  List<PayUser> paymentData = [];
  List<PayUser> lastfiveDayPayment = [];
  List<PayUser> originalData = [];
  double totalSum = 0.0;
  double lastFiveDaySum = 0.0;
  int numberOfEntries = 0;
  double totalAmount = 0.0;

  Future<void> getPaymentDetails() async {
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);

      var res = await http.post(
        Uri.parse(API.payRepDisplay),
        body: {
          'fromDate': formattedFromDate,
          'toDate': formattedToDate,
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfPaymentReport = jsonDecode(res.body);
        if (responseBodyOfPaymentReport["success"] == true) {
          List<PayUser> data =
              (responseBodyOfPaymentReport["paymentReportData"] as List)
                  .map((eachRecord) {
            return PayUser.fromJson(eachRecord);
          }).toList();

          paymentData = data;
          originalData = data; // Store the original data
          calculateTotalSum();
          getLastfiveDayPayment();
          update();
          // calculateEntriesAndTotalAmount();// Calculate the total sum
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }
  }

  void calculateTotalSum() {
    totalSum = paymentData.fold(
        0.0, (sum, item) => sum + double.parse(item.payment_amount));

    update();
  }

  void getLastfiveDayPayment() {
    final today = DateTime.now();

    final last5DaysDate = today.subtract(const Duration(days: 5));

    paymentData
        .where((payment) => DateFormat("yyyy-MM-dd")
            .parse(payment.payment_date)
            .isAfter(last5DaysDate))
        .toList()
        .forEach((element) {
      if (!lastfiveDayPayment
          .any((po) => po.payment_id == element.payment_id)) {
        lastfiveDayPayment.add(element);
      }
    });

    lastFiveDaySum = lastfiveDayPayment.fold(
        0.0, (sum, item) => sum + double.parse(item.payment_amount));
    update();
  }

  void resetSearch() {
    searchController.clear();

    paymentData = originalData; // Reset to the original data
    update();
  }
}
