import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/model/srclass.dart';
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class SaleReportController extends GetxController {
  var searchController = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  DateTime fromDate = DateTime.now(); // Provide default values here
  DateTime toDate = DateTime.now();
  List<SalReport> saleData = [];
  List<SalReport> originalData = [];
  List<SalReport> lastfiveDaySale = [];
  double totalSum = 0.0;
  // Inside the SaleReport class
  int vehicleCount = 0;
  double totalAmount = 0.0;
  double lastfiveDaySum = 0.0;
  int lastfiveDayVehicle = 0;
  double lastfiveDayWeight = 0.0;

  Future<void> getSaleDetails({String? partyId}) async {
    
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);
      var body = {
        'fromDate': formattedFromDate,
        'toDate': formattedToDate,
        'token': await RememberUserPrefs.sharedToken("", 1),
      };

      if (partyId!=null){
        if(partyId.toString().isNotEmpty) {
          body.addAll({'partyId': partyId});
        }
      }

      var res = await http.post(
        Uri.parse(API.saleRepDisplay),
        body: body,
      );
      if (res.statusCode == 200) {
        var responseBodyOfSaleReport = jsonDecode(res.body);
        // print(responseBodyOfSaleReport);
        if (responseBodyOfSaleReport["success"] == true) {
          List<SalReport> data =
              (responseBodyOfSaleReport["saleReportData"] as List)
                  .map((eachRecord) {
            return SalReport.fromJson(eachRecord);
          }).toList();

          saleData = data;
          originalData = data; // Store the original data
          calculateTotalSum();
          getLastfiveDaySale();

          vehicleCount = data.length;
          print(vehicleCount); // Calculate the total sum
          update();
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }
  }

  void getLastfiveDaySale() {
    final today = DateTime.now();

    final last5DaysDate = today.subtract(const Duration(days: 5));

    saleData
        .where((payment) => DateFormat("yyyy-MM-dd")
            .parse(payment.sale_date)
            .isAfter(last5DaysDate))
        .toList()
        .forEach((element) {
      if (!lastfiveDaySale.any((po) => po.sale_id == element.sale_id)) {
        lastfiveDaySale.add(element);
      }
    });

    lastfiveDaySum = lastfiveDaySale.fold(
        0.0, (sum, item) => sum + double.parse(item.sale_total));

    lastfiveDayWeight = lastfiveDaySale.fold(
        0.0, (sum, item) => sum + double.parse(item.sale_ntwt));
    lastfiveDayVehicle = lastfiveDaySale.length;
    update();
  }

  void calculateTotalSum() {
    totalSum =
        saleData.fold(0.0, (sum, item) => sum + double.parse(item.sale_total));
    update();
  }
}
