import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/model/paymasclass.dart';
import 'package:trans_port/model/prclass.dart';
import 'package:trans_port/model/rpclass.dart';
import 'package:trans_port/model/srclass.dart';
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class PartyReportController extends GetxController {
  var searchController = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  DateTime fromDate = DateTime.now(); // Provide default values here
  DateTime toDate = DateTime.now();

  //Sale Data
  List<SalReport> salesaleData = [];
  List<SalReport> saleoriginalData = [];
  List<SalReport> salelastfiveDaySale = [];
  double saletotalSum = 0.0;
  int salevehicleCount = 0;
  double saletotalAmount = 0.0;
  double salelastfiveDaySum = 0.0;
  int salelastfiveDayVehicle = 0;
  double salelastfiveDayWeight = 0.0;

//pur report

  List<PurReport> purchaseData = [];
  List<PurReport> purchseoriginalData = [];
  List<PurReport> lastfiveDayPurchase = [];
  double purtotalSum = 0.0;
  double lastfiveDaySum = 0.0;
  int lastfiveDayVehicle = 0;
  double lastfiveDayWeight = 0.0;

  //Payment Data
  List<PayUser> paymentpaymentData = [];
  List<PayUser> paymentlastfiveDayPayment = [];
  List<PayUser> paymentoriginalData = [];
  double paymenttotalSum = 0.0;
  double paymentlastFiveDaySum = 0.0;
  int paymentnumberOfEntries = 0;
  double paymenttotalAmount = 0.0;

//Reciept Report
  List<RecUser> receiptData = [];
  List<RecUser> receioptOriginalData = [];
  List<RecUser> lastfiveDayReceipt = [];
  double recieptTotalSum = 0.0;
  double lastFiveDayRecieptSum = 0.0;

  //Total Data
  double totalSale = 0.0;
  double totalPurchase = 0.0;
  double totalReceipt = 0.0;
  double totalPayment = 0.0;
  double closingBalance = 0.0;
  double opningBalance = 0.0;

  Future<void> getSaleDetails({String? partyId}) async {
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);
      var body = {
        'fromDate': formattedFromDate,
        'toDate': formattedToDate,
        'token': await RememberUserPrefs.sharedToken("", 1),
      };
      if (partyId!.isNotEmpty) {
        body.addAll({'sale_customerid': partyId});
      }
      var res = await http.post(
        Uri.parse(API.saleRepDisplay),
        body: body,
      );
      if (res.statusCode == 200) {
        Map<String, dynamic> responseBodyOfSaleReport = jsonDecode(res.body);

        // print("responseBodyOfSaleReport here ${responseBodyOfSaleReport}");
        if (responseBodyOfSaleReport["success"] == true) {
          List<SalReport> data =
              (responseBodyOfSaleReport["saleReportData"] as List)
                  .map((eachRecord) {
            // print(eachRecord);
            return SalReport.fromJson(eachRecord);
          }).toList();
          // print("dddd");
          salesaleData = data;
          saleoriginalData = data; // Store the original data
          calculateTotalSum();
          getLastfiveDaySale();

          salevehicleCount = data.length;
          print(salevehicleCount); // Calculate the total sum
          update();
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }
  }

  Future<void> getPaymentDetails({String? partyId}) async {
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);
      var body = {
        'fromDate': formattedFromDate,
        'toDate': formattedToDate,
        'token': await RememberUserPrefs.sharedToken("", 1),
      };
      if (partyId!.isNotEmpty) {
        body.addAll({'payment_customerid': partyId});
      }
      print("body: $body");
      var res = await http.post(
        Uri.parse(API.payRepDisplay),
        body: body,
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> responseBodyOfPaymentReport = jsonDecode(res.body);
        // print(responseBodyOfPaymentReport);
        if (responseBodyOfPaymentReport["success"] == true) {
          List<PayUser> data =
              (responseBodyOfPaymentReport["paymentReportData"] as List)
                  .map((eachRecord) {
            return PayUser.fromJson(eachRecord);
          }).toList();

          paymentpaymentData = data;
          paymentoriginalData = data; // Store the original data
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

  Future<void> getPurchaseDetails({String? partyId}) async {
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
          'purchase_customerid': partyId,
        },
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> responseBodyOfPurchaseReport =
            jsonDecode(res.body);
        // print('responseBodyOfPurchaseReport: $responseBodyOfPurchaseReport');
        // print(res.body);
        if (responseBodyOfPurchaseReport["success"] == true) {
          List<PurReport> data =
              (responseBodyOfPurchaseReport["purchaseReportData"] as List)
                  .map((eachRecord) {
            return PurReport.fromJson(eachRecord);
          }).toList();

          purchaseData = data;
          purchseoriginalData = data;
          calculateTotalSum(); // Store the original data
          getLastfiveDayPurchase();
          update();
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }
  }

  Future<void> getReceiptDetails({String? partyId}) async {
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);

      var res = await http.post(
        Uri.parse(API.recRepDisplay),
        body: {
          'fromDate': formattedFromDate,
          'toDate': formattedToDate,
          'token': await RememberUserPrefs.sharedToken("", 1),
          'receipt_customerid': partyId,
        },
      );

      if (res.statusCode == 200) {
        // print(res.body);
        Map<String, dynamic> responseBodyOfReceiptReport = jsonDecode(res.body);
        // print('responseBodyOfReceiptReport: $responseBodyOfReceiptReport');

        if (responseBodyOfReceiptReport["success"] == true) {
          List<RecUser> data =
              (responseBodyOfReceiptReport["receiptReportData"] as List)
                  .map((eachRecord) {
            return RecUser.fromJson(eachRecord);
          }).toList();

          receiptData = data;
          receioptOriginalData = data; // Store the original data
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

  Future<void> getPartyDetailsById(
      {String? partyId,
      String? fun,
      String? selectedFromDate,
      String? selectedToDate}) async {
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(fromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(toDate);
      var body = {
        'fromDate': formattedFromDate,
        'toDate': formattedToDate,
        'token': await RememberUserPrefs.sharedToken("", 1),
      };
      if (partyId!.isNotEmpty && fun!.isNotEmpty) {
        body.addAll({'party_id': partyId, 'function': fun});
      }
      body.addAll({
        'selectedFromDate': formattedFromDate,
        'selectedToDate': formattedToDate
      });
      var res = await http.post(
        Uri.parse(API.clBalance),
        body: body,
      );

      if (res.statusCode == 200) {
        // print(res.body);
        var responseBodyOfSaleReport = jsonDecode(res.body);

        Map<String, dynamic> data = responseBodyOfSaleReport;
        if (data.containsKey('total_sales')) {
          this.totalSale = double.parse(data['total_sales']);
          update();
        }
        // print("Purchase data value : ${res.body} ");

        if (data.containsKey('total_purchases')) {
          this.totalPurchase = double.parse(data['total_purchases']);
          update();
        }
        if (data.containsKey('total_payments')) {
          this.totalPayment = double.parse(data['total_payments']);
          update();
        }
        if (data.containsKey('total_receipts')) {
          this.totalReceipt = double.parse(data['total_receipts']);
          update();
        }
        if (data.containsKey('closing_balance')) {
          closingBalance = double.parse(data['closing_balance'].toString());
          // print(closingBalance);
          update();
        }
        if (data.containsKey('opening_balance')) {
          opningBalance = double.parse(data['opening_balance'].toString());
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

    final last5DaysDate = today.subtract(Duration(days: 5));

    salesaleData
        .where((payment) => DateFormat("yyyy-MM-dd")
            .parse(payment.sale_date)
            .isAfter(last5DaysDate))
        .toList()
        .forEach((element) {
      if (!salelastfiveDaySale.any((po) => po.sale_id == element.sale_id)) {
        salelastfiveDaySale.add(element);
      }
    });

    salelastfiveDaySum = salelastfiveDaySale.fold(
        0.0, (sum, item) => sum + double.parse(item.sale_total));

    salelastfiveDayWeight = salelastfiveDaySale.fold(
        0.0, (sum, item) => sum + double.parse(item.sale_ntwt));
    salelastfiveDayVehicle = salelastfiveDaySale.length;
    update();
  }

  void getLastfiveDayPayment() {
    final today = DateTime.now();

    final last5DaysDate = today.subtract(Duration(days: 5));

    paymentpaymentData
        .where((payment) => DateFormat("yyyy/MM/dd")
            .parse(payment.payment_date)
            .isAfter(last5DaysDate))
        .toList()
        .forEach((element) {
      if (!paymentlastfiveDayPayment
          .any((po) => po.payment_id == element.payment_id)) {
        paymentlastfiveDayPayment.add(element);
      }
    });

    paymentlastFiveDaySum = paymentlastfiveDayPayment.fold(
        0.0, (sum, item) => sum + double.parse(item.payment_amount));
    update();
  }

  void getLastfiveDayReceipt() {
    final today = DateTime.now();

    final last5DaysDate = today.subtract(const Duration(days: 5));

    receiptData
        .where((payment) => DateFormat("yyyy/MM/dd")
            .parse(payment.receipt_date)
            .isAfter(last5DaysDate))
        .toList()
        .forEach((element) {
      if (!lastfiveDayReceipt
          .any((po) => po.receipt_id == element.receipt_id)) {
        lastfiveDayReceipt.add(element);
      }
    });

    lastFiveDayRecieptSum = lastfiveDayReceipt.fold(
        0.0, (sum, item) => sum + double.parse(item.receipt_amount));
    update();
  }

  void getLastfiveDayPurchase() {
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

  void calculateTotalSum() {
    saletotalSum = salesaleData.fold(
        0.0, (sum, item) => sum + double.parse(item.sale_total));
    update();

    paymenttotalSum = paymentpaymentData.fold(
        0.0, (sum, item) => sum + double.parse(item.payment_amount));
    update();

    recieptTotalSum = receiptData.fold(
        0.0, (sum, item) => sum + double.parse(item.receipt_amount));
    update();

    purtotalSum = purchaseData.fold(
        0.0, (sum, item) => sum + double.parse(item.purchase_total));
    update();
  }

  List<DataColumn> getPaymentColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text(
            'Pay No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Cust Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Amount',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Date',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.2,
          child: const Text('Ledger',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Pay Mode',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
    ];
  }

  List<DataColumn> getPurchaseColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.015,
          child: const Text(
            'Pur No.',
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Supp Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Vec No.',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Date',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.2,
          child: const Text('Net Wt',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Total',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
    ];
  }

  List<DataColumn> getRecieptColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text(
            'Rec No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Cust Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Amount',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Date',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.2,
          child: const Text('Ledger',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Pay Mode',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
    ];
  }

  List<DataColumn> getSaleColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text(
            'Sal No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Supp Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Vec No.',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Date',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.2,
          child: const Text('Net Wt',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Total',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
    ];
  }
}
