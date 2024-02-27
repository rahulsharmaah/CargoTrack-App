import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/model/cashbankclass.dart';
import 'package:trans_port/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import '../api_connection/api_connection.dart';
import '../model/rpclass.dart';
import '../utils/Utils.dart';

class ReceiptController extends GetxController {
  String? recLedger;
  var recdate = DateTime.now();
  var recdt = DateTime.now().toString();
  var recuid;
  //String? cashBank;
  PartyUser? selectedPartyUser;
  List<PartyUser> partyLedgers = [];
  String? partyOS;
  String? selectedCustomer;
  String? selectedCashBank;

  var recdateController = TextEditingController();
  var recledgerController = TextEditingController();
  var reccashbankController = TextEditingController();
  var reccustomerController = TextEditingController();
  var recamountController = TextEditingController();
  var recnotesController = TextEditingController();
  var reccreatedbyController = TextEditingController();
  var recdtController = TextEditingController();

  Future<List<CashBank>> getCashBank() async {
    List<CashBank> getCashBank = [];

    try {
      var res = await http.post(Uri.parse(API.cbSearch), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });
      
      if (res.statusCode == 200) {
        var responseBodyOfCashBank = jsonDecode(res.body);
        if (responseBodyOfCashBank["success"] == true) {
          for (var eachRecord
              in (responseBodyOfCashBank["cbNameData"] as List)) {
            getCashBank.add(CashBank.fromJson(eachRecord));
          }
        }
      } else {
        //print("Error, status code is not 200");
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return getCashBank;
  }

  Future<List<PartyUser>> getPartyLedgers() async {
    List<PartyUser> getPartyLedgers = [];

    try {
      var res = await http.post(Uri.parse(API.pLSearch), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });

      if (res.statusCode == 200) {
        // print('Server Error: ${res.statusCode} - ${res.body}');

        var responseBodyOfPartyLedger = jsonDecode(res.body);
        if (responseBodyOfPartyLedger["success"] == true) {
          for (var eachRecord
              in (responseBodyOfPartyLedger["partyLedgerData"] as List)) {
            getPartyLedgers.add(PartyUser.fromJson(eachRecord));
          }
        }
      } else {
        //print("Error, status code is not 200");
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return getPartyLedgers;
  }

  registerAndSaveReceipt() async {
    RecUser userModel = RecUser(
      1,
      recdateController.text = DateFormat('yyyy/MM/dd').format(recdate),
      recledgerController.text.trim(),
      reccashbankController.text.trim(),
      reccustomerController.text.trim(),
      recamountController.text.trim(),
      recnotesController.text.trim(),
      reccreatedbyController.text.trim(),
      recdtController.text.trim(), //= DateFormat('dd/MM/yyyy').format(recdate),
    );

    try {
      var res = await http.post(
        Uri.parse(API.recCreate),
        body: {
          ...userModel.toJson(),
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );
      print(res.body);

      if (res.statusCode == 200) {
        print('Server Error: ${res.statusCode} - ${res.body}');
        var resBodyOfReceiptMaster = jsonDecode(res.body);
        if (resBodyOfReceiptMaster['success'] == true) {
          Utils.showTost(msg: "Receipt Created Successfully.");
          recdateController.clear();
          recledgerController.clear();
          reccashbankController.clear();
          reccustomerController.clear();
          recamountController.clear();
          recnotesController.clear();
          recdtController.clear();

          recLedger = null;
          selectedCustomer = null;
          partyOS = null;
          selectedCashBank = null;
          update();
        } else {
          Utils.showTost(msg: "Error in Creation, Try Again");
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
    }
  }
}
