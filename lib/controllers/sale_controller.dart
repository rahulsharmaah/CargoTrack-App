import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/master/itemdetails_screen.dart';
import 'package:trans_port/model/spclass.dart';
import 'package:trans_port/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import '../api_connection/api_connection.dart';
import '../utils/Utils.dart';

class SaleController extends GetxController {
  String? saleCustomer;
  var saledate = DateTime.now();
  var saledt = DateTime.now().toString();
  var saleuid;
  PartyUser? selectedPartyUser;
  List<PartyUser> partyLedgers = [];
  String? partyOS;
  String? selectedCustomer;
  double salenetweight = 0.00;
  double netWeightLU = 0.00;
  double netWeightGross = 0.00;
  double totalAmount = 0.00;
  double addPercentage = 0.0;
  double dedPercentage = 0.0;
  double addValue = 0.0;
  double dedValue = 0.0;
  double adjustedTotal = 0.0;
  List<ItemSaleDetails> itemDetailsList = [];

  var saledateController = TextEditingController();
  var salecustomerController = TextEditingController();
  var salevehiclenoController = TextEditingController();
  var salelgwtController = TextEditingController();
  var saleugwtController = TextEditingController();
  var salentwtController = TextEditingController();
  var saleimnoController = TextEditingController();
  var saleaddController = TextEditingController();
  var salededController = TextEditingController();
  var saletotalController = TextEditingController();
  var salecreatedbyController = TextEditingController();
  var saledtController = TextEditingController();

  Future<List<PartyUser>> getPartyLedgers() async {
    List<PartyUser> getPartyLedgers = [];

    try {
      var res = await http.post(Uri.parse(API.pLSearch), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });

      if (res.statusCode == 200) {
        var responseBodyOfPartyLedger = jsonDecode(res.body);
        if (responseBodyOfPartyLedger["success"] == true) {
          for (var eachRecord
              in (responseBodyOfPartyLedger["partyLedgerData"] as List)) {
            getPartyLedgers.add(PartyUser.fromJson(eachRecord));
          }
        }
      } else {
        print("Error, status code is not 200");
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
      Utils.showTost(msg: "Error: $errorMsg");
    }

    return getPartyLedgers;
  }

  registerAndSaveSale() async {
    final saleData = {
      "sale_date": DateFormat('yyyy-MM-dd').format(saledate),
      "sale_customer": salecustomerController.text.trim(),
      "sale_vehicleno": salevehiclenoController.text.trim(),
      "sale_lgwt": salelgwtController.text.trim(),
      "sale_ugwt": saleugwtController.text.trim(),
      "sale_ntwt": salentwtController.text.trim(),
      "sale_imno": saleimnoController.text.trim(),
      "sale_add": saleaddController.text.trim(),
      "sale_ded": salededController.text.trim(),
      "sale_total": saletotalController.text.trim(),
      "sale_createdby": salecreatedbyController.text.trim(),
      "sale_dt": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "item_details": itemDetailsList.map((item) => item.toJson()).toList(),
    };
    try {
      final response = await http.post(
        Uri.parse(API.saleCreate),
        headers: {
          'Content-Type': 'application/json', // Set the content type
        },
        body: jsonEncode({
          ...saleData,
          "token": await RememberUserPrefs.sharedToken("", 1),
        }),
      );

      if (response.statusCode == 200) {
        var resBodyOfSaleMaster = jsonDecode(response.body);
        print(resBodyOfSaleMaster);
        if (resBodyOfSaleMaster['success'] == true) {
          Utils.showTost(msg: "Sale Created Successfully.");
          itemDetailsList.clear();
          saledateController.clear();
          salecustomerController.clear();
          salevehiclenoController.clear();
          salelgwtController.clear();
          saleugwtController.clear();
          salentwtController.clear();
          saleimnoController.clear();
          saleaddController.clear();
          salededController.clear();
          saletotalController.clear();
          saledtController.clear();
          selectedCustomer = null;
          partyOS = null;
          update();
        } else {
          Utils.showTost(msg: "Error in Creations, Try Again");
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
      print('Error parsing JSON: $e');
    }
  }

  void addItemDetails(ItemDetails itemDetails) {
    itemDetailsList.add(ItemSaleDetails(
      item_name: itemDetails.itemName,
      item_qty: itemDetails.weightInKgs,
      item_rate: itemDetails.ratePerKg,
    ));
    calculateTotalAmount();
    calculateAdjustedTotal();
    update();
  }

  void calculateTotalAmount() {
    totalAmount = 0.0; // Reset total amount before recalculating

    for (var itemDetail in itemDetailsList) {
      totalAmount += itemDetail.item_qty * itemDetail.item_rate;
    }
    calculateAdjustedTotal();
  }

  String formatDecimal(double value) {
    return value.toStringAsFixed(2);
  }

  double calculateItemsTotal() {
    double itemsTotal = 0.0;

    for (var itemDetail in itemDetailsList) {
      itemsTotal += itemDetail.item_qty * itemDetail.item_rate;
    }
    totalAmount = itemsTotal;
    return itemsTotal;
  }

  void calculateAdjustedTotal() {
    double itemsTotal = calculateItemsTotal();
    adjustedTotal = totalAmount + addValue - dedValue;
    saletotalController.text = adjustedTotal.toStringAsFixed(2);
  }

  double calculateItemTotal() {
    double itemTotal = 0.0;

    for (var itemDetails in itemDetailsList) {
      itemTotal += itemDetails.item_qty * itemDetails.item_rate;
    }

    return itemTotal;
  }

  void calculateNetWeight() {
    double loadingWeight = double.tryParse(salelgwtController.text) ?? 0.0;
    double unloadingWeight = double.tryParse(saleugwtController.text) ?? 0.0;

    //double grossWeight = loadingWeight - unloadingWeight;
    double netWeight = loadingWeight - unloadingWeight;

    //netWeightGross = grossWeight;
    salenetweight = netWeight;

    salentwtController.text = netWeight.toStringAsFixed(2);
    update();
  }

  void calculateGrossWeight() {
    double loadingWeight = double.tryParse(salelgwtController.text) ?? 0.0;
    double unloadingWeight = double.tryParse(saleugwtController.text) ?? 0.0;

    double netWeight = loadingWeight - unloadingWeight;

    //netWeightGross = grossWeight;
    salenetweight = netWeight;
    update();
  }
}
