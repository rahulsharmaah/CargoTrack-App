import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/model/purclass.dart';
import 'package:trans_port/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import '../api_connection/api_connection.dart';
import '../utils/Utils.dart';

class PurchaseController extends GetxController {
  String? purCustomer;
  var purdate = DateTime.now();
  var purdt = DateTime.now().toString();
  var puruid;
  PartyUser? selectedPartyUser;
  List<PartyUser> partyLedgers = [];
  String? partyOS;
  String? selectedCustomer;
  double purnetweight = 0.00;
  double netWeightLU = 0.00;
  double netWeightGross = 0.00;
  double totalAmount = 0.00;
  double addPercentage = 0.0;
  double dedPercentage = 0.0;
  double addValue = 0.0;
  double dedValue = 0.0;
  double adjustedTotal = 0.0;
  List<ItemPurchaseDetails> itemDetailsList = [];

  var purdateController = TextEditingController();
  var purcustomerController = TextEditingController();
  var purvehiclenoController = TextEditingController();
  var purlgwtController = TextEditingController();
  var purugwtController = TextEditingController();
  var purgrossController = TextEditingController();
  var purdustController = TextEditingController();
  var purntwtController = TextEditingController();
  var purimnoController = TextEditingController();
  var puraddController = TextEditingController();
  var purdedController = TextEditingController();
  var purtotalController = TextEditingController();
  var purcreatedbyController = TextEditingController();
  var purdtController = TextEditingController();

  Future<List<PartyUser>> getPartyLedgers() async {
    List<PartyUser> getPartyLedgers = [];

    try {
      var res = await http.post(Uri.parse(API.pLSearch), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });

      if (res.statusCode == 200) {
        // print("Response body: ${res.body}");
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

  registerAndSavePurchase() async {
    final purchaseData = {
      "purchase_date": DateFormat('yyyy-MM-dd').format(purdate),
      "purchase_customer": purcustomerController.text.trim(),
      "purchase_vehicleno": purvehiclenoController.text.trim(),
      "purchase_lgwt": purlgwtController.text.trim(),
      "purchase_ugwt": purugwtController.text.trim(),
      "purchase_gross": purgrossController.text.trim(),
      "purchase_dust": purdustController.text.trim(),
      "purchase_ntwt": purntwtController.text.trim(),
      "purchase_imno": purimnoController.text.trim(),
      "purchase_add": puraddController.text.trim(),
      "purchase_ded": purdedController.text.trim(),
      "purchase_total": purtotalController.text.trim(),
      "purchase_createdby": purcreatedbyController.text.trim(),
      "purchase_dt": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "item_details": itemDetailsList.map((item) => item.toJson()).toList(),
    };

    try {
      var token = await RememberUserPrefs.sharedToken("", 1);

      // var res = await http.post(
      //   Uri.parse(API.purCreate),
      //   body: userModel.toJson(),
      final response = await http.post(
        Uri.parse(API.purCreate),
        headers: {
          'Content-Type': 'application/json', // Set the content type
        },
        body: jsonEncode({
          ...purchaseData,
          'token': token,
        }),
// Encode the data as JSON
      );
      print(token);
      if (response.statusCode == 200) {
        var resBodyOfPurchaseMaster = jsonDecode(response.body);
        // print(resBodyOfPurchaseMaster);
        if (resBodyOfPurchaseMaster['success'] == true) {
          Utils.showTost(msg: "Purchase Created Successfully.");
          //setState(() {
          itemDetailsList.clear();
          purdateController.clear();
          purcustomerController.clear();
          purvehiclenoController.clear();
          purlgwtController.clear();
          purugwtController.clear();
          purgrossController.clear();
          purdustController.clear();
          purntwtController.clear();
          purimnoController.clear();
          puraddController.clear();
          purdedController.clear();
          purtotalController.clear();
          purdtController.clear();
          selectedCustomer = null;
          partyOS = null;
          update();
          //});
        } else {
          Utils.showTost(msg: "Error in Creation, Try Again");
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
      print('Error parsing JSON: $e');
    }
  }
}
