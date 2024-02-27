import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:trans_port/api_connection/api_connection.dart';
import 'package:trans_port/fragments/sales_screen.dart';
import 'package:trans_port/model/itemclass.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ItemDetails? initialItemDetails;
  const ItemDetailsScreen({super.key, this.initialItemDetails});

  @override
  //State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  var formKey = GlobalKey<FormState>();
  var formKey1 = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var selectedItem;
  var itemAmountTotal;
  var itemNameController = TextEditingController();
  var weightinkgsController = TextEditingController();
  var rateinkgController = TextEditingController();
  var calculatedValueController = TextEditingController();

  void calculateAndSetCalculatedValue() {
    double weightInKgs = double.tryParse(weightinkgsController.text) ?? 0.0;
    double ratePerKg = double.tryParse(rateinkgController.text) ?? 0.0;

    double calculatedValue = weightInKgs * ratePerKg;

    calculatedValueController.text = calculatedValue.toStringAsFixed(2);
  }

  Future<List<ItemUser>> getItemName() async {
    List<ItemUser> getItemName = [];

    try {
      var res = await http.post(Uri.parse(API.iLSearch), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });

      if (res.statusCode == 200) {
        var responseBodyOfItemName = jsonDecode(res.body);
        if (responseBodyOfItemName["success"] == true) {
          for (var eachRecord
              in (responseBodyOfItemName["itemNameData"] as List)) {
            getItemName.add(ItemUser.fromJson(eachRecord));
          }
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return getItemName;
  }

  void _saveItemDetails() {
    // Logic to save the entered item details
    String itemName = itemNameController.text;
    double weightInKgs = double.parse(weightinkgsController.text);
    double ratePerKg = double.parse(rateinkgController.text);

    // Here you can pass the item details back to the SalesScreen
    Navigator.pop(context, ItemDetails(itemName, weightInKgs, ratePerKg));
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialItemDetails != null) {
      itemNameController.text = widget.initialItemDetails!.itemName;
      weightinkgsController.text =
          widget.initialItemDetails!.weightInKgs.toString();
      rateinkgController.text = widget.initialItemDetails!.ratePerKg.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Item Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            //color: Colors.cyan,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.teal.shade100),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: FutureBuilder<List<ItemUser>>(
                    future: getItemName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("Empty, No Data."),
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  "Item Name",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                DropdownButton<String>(
                                  value: selectedItem,
                                  hint: const Text("Select Item"),
                                  items: snapshot.data!
                                      .map((eachPartyLedgerRecord) {
                                    return DropdownMenuItem<String>(
                                      value: eachPartyLedgerRecord.item_name,
                                      child:
                                          Text(eachPartyLedgerRecord.item_name),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedItem = value;
                                        itemNameController.text = value;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Form(
                        key: formKey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Weight in Kg"),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: weightinkgsController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Weight in Kg',
                                ),
                                onChanged: (_) {
                                  calculateAndSetCalculatedValue();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Weight';
                                  }
                                  return null;
                                },
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: Form(
                        key: formKey1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(" Rate per Kg "),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: rateinkgController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Rate per Kg',
                                ),
                                onChanged: (_) {
                                  calculateAndSetCalculatedValue();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Rate';
                                  }
                                  return null;
                                },
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: calculatedValueController,
                    enabled: false,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () {
                            _saveItemDetails();
                            
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            child: Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const SaleScreen());

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
                                color: Colors.white,
                                fontSize: 15,
                              ),
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
    );
  }
}

Widget itemDetailsFields(
    BuildContext context, String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 1),
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.center,
              child: Text(label),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                controller: controller,
                onChanged: (value) {
                  // _calculateTotal();
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
                keyboardType: TextInputType.number,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class ItemDetails {
  final String itemName;
  final double weightInKgs;
  final double ratePerKg;

  ItemDetails(this.itemName, this.weightInKgs, this.ratePerKg);
}

void main() {
  runApp(const MaterialApp(
    home: ItemDetailsScreen(),
  ));
}
