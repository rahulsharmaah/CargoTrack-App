import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/model/prclass.dart';
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class PurchaseReportController extends GetxController {
  var searchController = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  DateTime fromDate = DateTime.now(); // Provide default values here
  DateTime toDate = DateTime.now();

  List<PurReport> purchaseData = [];
  List<PurReport> originalData = [];
  List<PurReport> lastfiveDayPurchase = [];
  double totalSum = 0.0;
  double lastfiveDaySum = 0.0;
  int lastfiveDayVehicle = 0;
  double lastfiveDayWeight = 0.0;

  Future<void> getPurchaseDetails() async {
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);

      print('Fetching data from $formattedFromDate to $formattedToDate');

      var res = await http.post(
        Uri.parse(API.purRepDisplay),
        body: {
          'fromDate': formattedFromDate,
          'toDate': formattedToDate,
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );

      if (res.statusCode == 200) {
        print(res.body);
        var responseBodyOfPurchaseReport = jsonDecode(res.body);
        if (responseBodyOfPurchaseReport["success"] == true) {
          List<PurReport> data =
              (responseBodyOfPurchaseReport["purchaseReportData"] as List)
                  .map((eachRecord) {
            return PurReport.fromJson(eachRecord);
          }).toList();
          purchaseData = data;
          originalData = data;
          calculateTotalSum(); // Store the original data
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
    totalSum = purchaseData.fold(
        0.0, (sum, item) => sum + double.parse(item.purchase_total));
  }

  void getLastfiveDayReceipt() {
    final today = DateTime.now();

    final last5DaysDate = today.subtract(const Duration(days: 5));

    purchaseData
        .where((payment) => DateFormat("yyyy-MM-dd")
            .parse(payment.purchase_date)
            .isAfter(last5DaysDate))
        .toList()
        .forEach((element) {
      if (!lastfiveDayPurchase
          .any((po) => po.purchase_id == element.purchase_id)) {
        lastfiveDayPurchase.add(element);
      }
    });

    lastfiveDaySum = lastfiveDayPurchase.fold(
        0.0, (sum, item) => sum + double.parse(item.purchase_total));

    lastfiveDayWeight = lastfiveDayPurchase.fold(
        0.0, (sum, item) => sum + double.parse(item.purchase_ntwt));
    lastfiveDayVehicle = lastfiveDayPurchase.length;
    update();
  }

  void filterData(
      String searchText, DateTime selectedFromDate, DateTime selectedToDate) {
    purchaseData = originalData.where((item) {
      final purchaseDate = DateTime.parse(item
          .purchase_date); // Assuming purchase_date is in a format that can be parsed as DateTime
      final searchQuery = searchText.toLowerCase();
      print("here");
      // Check if the purchaseDate is within the selected date range
      bool isWithinDateRange =
          purchaseDate.isAtSameMomentAs(selectedFromDate) ||
              purchaseDate.isAtSameMomentAs(selectedToDate) ||
              (purchaseDate.isAfter(selectedFromDate) &&
                  purchaseDate.isBefore(selectedToDate));

      return isWithinDateRange &&
          (item.purchase_customer.toLowerCase().contains(searchQuery) ||
              item.purchase_id.toString().contains(searchQuery) ||
              item.purchase_total.toLowerCase().contains(searchQuery) ||
              item.purchase_vehicleno.toLowerCase().contains(searchQuery) ||
              item.purchase_ntwt.toLowerCase().contains(searchQuery) ||
              item.purchase_date.toLowerCase().contains(searchQuery));
    }).toList();
    update();
  }
}
