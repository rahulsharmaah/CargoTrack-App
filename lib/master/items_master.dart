import 'dart:convert';

import 'package:trans_port/api_connection/api_connection.dart';
import 'package:trans_port/master/item_screen.dart';
import 'package:trans_port/model/itemclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

class ItemsMasterScreen extends StatefulWidget {
  const ItemsMasterScreen({super.key});

  @override
  State<ItemsMasterScreen> createState() => _ItemsMasterScreenState();
}

class _ItemsMasterScreenState extends State<ItemsMasterScreen> {
  var formKey = GlobalKey<FormState>();

  var itemnameController = TextEditingController();
  var item_active = "Active";
  // var party_active = TextEditingController();

  validateItemName() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateItemName),
        body: {
          'item_name': itemnameController.text.trim(),
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfValidateItemName = jsonDecode(res.body);

        if (resBodyOfValidateItemName['itemNameFound'] == true) {
          Utils.showTost(msg: "Item Already Exists");
        } else {
          registerAndSaveItemMaster();
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
    }
  }

  registerAndSaveItemMaster() async {
    ItemUser itemModel = ItemUser(
      1,
      itemnameController.text.trim(),
      item_active,
    );
    try {
      var res = await http.post(Uri.parse(API.imCreate), body: {
        ...itemModel.toJson(),
        'token': await RememberUserPrefs.sharedToken("", 1),
      });
      if (res.statusCode == 200) {
        var resBodyOfItemMaster = jsonDecode(res.body);
        if (resBodyOfItemMaster['success'] == true) {
          Utils.showTost(msg: "Item Created Successfully.");
          setState(() {
            itemnameController.clear();
            //partyobController.clear();
            item_active;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
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
                          Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 9,
                            color: Colors.white70,
                            offset: Offset(0, -3),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 9),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 21,
                                ),
                                TextFormField(
                                  controller: itemnameController,
                                  validator: (val) =>
                                      val == "" ? "Item Name" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.imagesearch_roller_sharp,
                                      color: Colors.black,
                                    ),
                                    hintText: "Item Name",
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
                                    contentPadding: const EdgeInsets.all(18.0),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                SizedBox(
                                  height: 120,
                                  width: 180,
                                  child: Column(
                                    children: [
                                      RadioListTile(
                                        title: const Text("Active"),
                                        value: "Active",
                                        groupValue: item_active,
                                        onChanged: (value) {
                                          {
                                            setState(() {
                                              item_active = value.toString();
                                            });
                                          }
                                        },
                                      ),
                                      RadioListTile(
                                        title: const Text("Disable Item"),
                                        value: "disableitem",
                                        groupValue: item_active,
                                        onChanged: (value) {
                                          {
                                            setState(() {
                                              item_active = value.toString();
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
                                        validateItemName();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 28,
                                      ),
                                      child: Text(
                                        "Create Item",
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
                                      Get.to(() => const ItemMasterScreen());
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 28,
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
