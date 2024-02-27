import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trans_port/api_connection/api_connection.dart';
import 'package:trans_port/master/cashbank_master.dart';
import 'package:trans_port/model/cashbankclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';

import '../utils/Utils.dart';

class CashBankMasterScreen extends StatefulWidget {
  const CashBankMasterScreen({super.key});

  @override
  State<CashBankMasterScreen> createState() => _CashBankMasterScreenState();
}

class _CashBankMasterScreenState extends State<CashBankMasterScreen> {
  var formKey = GlobalKey<FormState>();

  var cbdate = DateTime.now();
  var cbdateController = TextEditingController();
  var cashbankController = TextEditingController();
  var cbobController = TextEditingController();
  var cb_active = "Active";

  validateCashBankName() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateCbName),
        body: {
          'cb_date': cbdateController.text.trim(),
          'cb_name': cashbankController.text.trim(),
          'cb_ob': cbobController.text.trim(),
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfValidateCBName = jsonDecode(res.body);
  
        if (resBodyOfValidateCBName['cashbankNameFound'] == true) {
          Utils.showTost(msg: "Cash/Bank Already Exists");
        } else {
          registerAndSaveCbMaster();
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
    }
  }

  registerAndSaveCbMaster() async {
    CashBank itemModel = CashBank(
      1,
      cbdateController.text.trim(),
      cashbankController.text.trim(),
      cbobController.text.trim(),
      cb_active,
    );
    try {
      var res = await http.post(
        Uri.parse(API.cbCreate),
        body: {
          ...itemModel.toJson(),
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfCbMaster = jsonDecode(res.body);
        if (resBodyOfCbMaster['success'] == true) {
          Utils.showTost(msg: "Cash/Bank Created Successfully.");
          setState(() {
            cbdateController.clear();
            cashbankController.clear();
            cb_active;
          });
        } else {
          Utils.showTost(msg: "Error in Creation, Try Again");
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    cbdateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: cons.maxHeight),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Image.asset("images/logo.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(
                          Radius.circular(45),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 9,
                            color: Colors.white70,
                            offset: Offset(0, -3),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 15, 25, 9),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 18,
                                ),
                                TextFormField(
                                  controller: cashbankController,
                                  validator: (val) =>
                                      val == "" ? "Bank or Cash" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.comment_bank_outlined,
                                      color: Colors.black,
                                    ),
                                    hintText: "Bank or Cash",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        )),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.purple,
                                        )),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    contentPadding: const EdgeInsets.all(15.0),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: cbobController,
                                  validator: (val) =>
                                      val == "" ? "Bank/Cash OB" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.money,
                                      color: Colors.black,
                                    ),
                                    hintText: "Bank/Cash OB",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        )),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.purple,
                                        )),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    contentPadding: const EdgeInsets.all(15.0),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                SizedBox(
                                  height: 180,
                                  width: 180,
                                  child: Column(
                                    children: [
                                      RadioListTile(
                                        title: const Text("Active"),
                                        value: "Active",
                                        groupValue: cb_active,
                                        onChanged: (value) {
                                          {
                                            setState(() {
                                              cb_active = value.toString();
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      RadioListTile(
                                        title: const Text("Disable Cash/Bank"),
                                        value: "disable",
                                        groupValue: cb_active,
                                        onChanged: (value) {
                                          {
                                            setState(() {
                                              cb_active = value.toString();
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        validateCashBankName();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 24,
                                      ),
                                      child: Text(
                                        "Create ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 19,
                                ),
                                Material(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => const CashBankScreen());
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 24,
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
