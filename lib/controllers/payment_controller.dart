import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/model/paymasclass.dart';
import 'package:trans_port/api_connection/api_connection.dart';
import 'package:trans_port/model/user.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/userPreferences/user_preferences.dart';
import '../model/cashbankclass.dart';
import '../utils/Utils.dart';

class PaymentController extends GetxController {
  String? payLedger;
  var paydate = DateTime.now();
  var paydt = DateTime.now().toString();
  var payuid;
  //String? cashBank;
  PartyUser? selectedPartyUser;
  List<PartyUser> partyLedgers = [];
  String? partyOS;
  String? selectedCustomer;
  String? selectedCashBank;

  var paydateController = TextEditingController();
  var payledgerController = TextEditingController();
  var paycashbankController = TextEditingController();
  var paycustomerController = TextEditingController();
  var payamountController = TextEditingController();
  var payrefController = TextEditingController();
  var paynotesController = TextEditingController();
  var paycreatedbyController = TextEditingController();
  var paydtController = TextEditingController();

  Future<List<CashBank>> getCashBank() async {
    List<CashBank> getCashBank = [];

    try {
      var res = await http.post(Uri.parse(API.cbSearch), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });
      if (res.statusCode == 200) {
        // print("Response body: ${res.statusCode} -${res.body}");
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
        var responseBodyOfPartyLedger = jsonDecode(res.body);
        if (responseBodyOfPartyLedger["success"] == true) {
          for (var eachRecord
              in (responseBodyOfPartyLedger["partyLedgerData"] as List)) {
            getPartyLedgers.add(PartyUser.fromJson(eachRecord));
          }
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return getPartyLedgers;
  }

  registerAndSavePayment() async {
    PayUser userModel = PayUser(
        1,
        paydateController.text = DateFormat('yyyy/MM/dd').format(paydate),
        payledgerController.text.trim(),
        paycashbankController.text.trim(),
        paycustomerController.text.trim(),
        payamountController.text.trim(),
        payrefController.text.trim(),
        paynotesController.text.trim(),
        paycreatedbyController.text.trim(),
        paydtController.text.trim());
    //userModel.payment_cb = cashBank;

    try {
      var res = await http.post(Uri.parse(API.payCreate), body: {
        ...userModel.toJson(),
        'token': await RememberUserPrefs.sharedToken("", 1),
      });
      if (res.statusCode == 200) {
        var resBodyOfPaymentMaster = jsonDecode(res.body);
        if (resBodyOfPaymentMaster['success'] == true) {
          Utils.showTost(msg: "Payment Created Successfully.");
          paydateController.clear();
          payledgerController.clear();
          paycashbankController.clear();
          paycustomerController.clear();
          payamountController.clear();
          payrefController.clear();
          paynotesController.clear();
          paydtController.clear();
          payLedger = null;
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
