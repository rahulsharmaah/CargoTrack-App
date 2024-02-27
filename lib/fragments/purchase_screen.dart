import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/purchase_controller.dart';
import 'package:trans_port/fragments/dashboard_of_fragments.dart';
import 'package:trans_port/master/itemdetails_screen.dart';
import 'package:trans_port/model/purclass.dart';
import 'package:trans_port/model/user.dart';
import 'package:trans_port/userPreferences/current_user.dart';
import 'package:trans_port/utils/Utils.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  var formKey = GlobalKey<FormState>();
  var formKey1 = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var formKey3 = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final purchase_controller = Get.put(PurchaseController());

  @override
  void initState() {
    super.initState();
    _loadUserData();

    purchase_controller.purdt =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    // purlgwtController.addListener(calculateNetWeight);
    purchase_controller.purugwtController.addListener(calculateNetWeight);
    purchase_controller.purdustController.addListener(calculateNetWeight);

    purchase_controller.puraddController.addListener(() {
      setState(() {
        purchase_controller.addValue =
            double.tryParse(purchase_controller.puraddController.text) ?? 0.0;
        calculateAdjustedTotal();
        purchase_controller.update();
      });
    });

    purchase_controller.purdedController.addListener(() {
      setState(() {
        purchase_controller.dedValue =
            double.tryParse(purchase_controller.purdedController.text) ?? 0.0;
        calculateAdjustedTotal();
        purchase_controller.update();
      });
    });
    calculateAdjustedTotal();
  }

  _loadUserData() async {
    await _currentUser.getUserInfo();
    setState(() {
      purchase_controller.purcreatedbyController.text =
          _currentUser.user?.user_id.toString() ?? '';
    }); // Trigger a state update to re-render the UI
  }

  bool validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false; // Validation failed
    }
    if (purchase_controller.selectedCustomer == null) {
      //|| puramountController.text.isEmpty
      return false; // Missing required fields
    }
    return true; // Validation passed
  }

  // List to store item details

  void _addItemDetails(ItemDetails itemDetails) {
    setState(() {
      purchase_controller.itemDetailsList.add(ItemPurchaseDetails(
        item_name: itemDetails.itemName,
        item_qty: itemDetails.weightInKgs,
        item_rate: itemDetails.ratePerKg,
        //item_dis: 'itemDetails.discount',
      ));
      calculateTotalAmount();
      calculateAdjustedTotal();
      purchase_controller.update();
    });
  }

  // void _addItemDetails(ItemDetails itemDetails) {
  //   setState(() {
  //     itemDetailsList.add(itemDetails);
  //     calculateTotalAmount();
  //     calculateAdjustedTotal();// Add item details to the list
  //   });
  // }

  void calculateTotalAmount() {
    purchase_controller.totalAmount =
        0.0; // Reset total amount before recalculating

    for (var itemDetail in purchase_controller.itemDetailsList) {
      purchase_controller.totalAmount +=
          itemDetail.item_qty * itemDetail.item_rate;
    }
    calculateAdjustedTotal();
  }

  String formatDecimal(double value) {
    return value.toStringAsFixed(2);
  }

  double calculateItemsTotal() {
    double itemsTotal = 0.0;

    for (var itemDetail in purchase_controller.itemDetailsList) {
      itemsTotal += itemDetail.item_qty * itemDetail.item_rate;
    }
    purchase_controller.totalAmount = itemsTotal;
    return itemsTotal;
  }

  void calculateAdjustedTotal() {
    double itemsTotal = calculateItemsTotal();
    purchase_controller.adjustedTotal = purchase_controller.totalAmount +
        purchase_controller.addValue -
        purchase_controller.dedValue;
    purchase_controller.purtotalController.text =
        purchase_controller.adjustedTotal.toStringAsFixed(2);
  }

  double calculateItemTotal() {
    double itemTotal = 0.0;

    for (var itemDetails in purchase_controller.itemDetailsList) {
      itemTotal += itemDetails.item_qty * itemDetails.item_rate;
    }

    return itemTotal;
  }

  void calculateNetWeight() {
    double loadingWeight =
        double.tryParse(purchase_controller.purlgwtController.text) ?? 0.0;
    double unloadingWeight =
        double.tryParse(purchase_controller.purugwtController.text) ?? 0.0;
    double dustWeight =
        double.tryParse(purchase_controller.purdustController.text) ?? 0.0;

    double grossWeight = loadingWeight - unloadingWeight;
    double netWeight = grossWeight - dustWeight;

    setState(() {
      purchase_controller.netWeightGross = grossWeight;
      purchase_controller.purnetweight = netWeight;

      purchase_controller.purgrossController.text =
          purchase_controller.netWeightGross.toStringAsFixed(2);
      purchase_controller.purntwtController.text = netWeight.toStringAsFixed(2);
    });
  }

  void calculateGrossWeight() {
    double loadingWeight =
        double.tryParse(purchase_controller.purlgwtController.text) ?? 0.0;
    double unloadingWeight =
        double.tryParse(purchase_controller.purugwtController.text) ?? 0.0;
    double dustWeight =
        double.tryParse(purchase_controller.purdustController.text) ?? 0.0;

    double grossWeight = loadingWeight - unloadingWeight;
    double netWeight = grossWeight - dustWeight;

    setState(() {
      purchase_controller.netWeightGross = grossWeight;
      purchase_controller.purnetweight = netWeight;
      purchase_controller.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "New PURCHASE",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 25, top: 1, bottom: 1),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Date  : ',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Center(
                          child: Text(
                            DateFormat('dd/MM/yyyy')
                                .format(purchase_controller.purdate),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            size: 18,
                          ),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: purchase_controller.purdate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                purchase_controller.purdate = pickedDate;
                                purchase_controller.purdateController.text =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);
                                purchase_controller.purdtController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                purchase_controller.update();
                              });
                            } else {
                              setState(() {
                                purchase_controller.purdate =
                                    DateTime.now(); // Set the default value
                                purchase_controller.purdateController.text =
                                    DateFormat('dd/MM/yyyy')
                                        .format(purchase_controller.purdate);
                                purchase_controller.purdtController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(purchase_controller.purdate);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 38, top: 1, bottom: 1),
              child: FutureBuilder<List<PartyUser>>(
                future: purchase_controller.getPartyLedgers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Empty, No Data."),
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text("Customer       "),
                            DropdownButton<String>(
                              value: purchase_controller.selectedCustomer,
                              hint: const Text("Select Customer"),
                              items:
                                  snapshot.data!.map((eachPartyLedgerRecord) {
                                return DropdownMenuItem<String>(
                                  value: eachPartyLedgerRecord.party_name,
                                  child: Text(eachPartyLedgerRecord.party_name),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    purchase_controller.selectedCustomer =
                                        value;
                                    purchase_controller
                                        .purcustomerController.text = value;
                                    purchase_controller.partyOS = snapshot.data!
                                        .firstWhere((party) =>
                                            party.party_name == value)
                                        .party_ob;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        if (purchase_controller.partyOS != null)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 30.0),
                                      child:
                                          Text("Outstanding Balance :  Rs. "),
                                    ),
                                    Text(
                                      "${purchase_controller.partyOS}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 45, top: 1, bottom: 1),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Column(
                        children: [
                          purchaseFields(context, "Vehicle No.",
                              purchase_controller.purvehiclenoController),
                          const SizedBox(
                            height: 5,
                          ),
                          purchaseFields(context, "Loading Wt",
                              purchase_controller.purlgwtController),
                          const SizedBox(
                            height: 5,
                          ),
                          purchaseFields(context, "Unloading Wt",
                              purchase_controller.purugwtController),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 80, top: 1, bottom: 1),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Gross Weight"),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            formatDecimal(purchase_controller.netWeightGross),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ]),
                  ),
                ) // netweight
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 45, top: 1, bottom: 1),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Column(
                        children: [
                          purchaseFields(context, "Dust Wt",
                              purchase_controller.purdustController),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 80, top: 1, bottom: 1),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Net Weight"),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            formatDecimal(purchase_controller.purnetweight),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ]),
                  ),
                ) // netweight
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 45, top: 1, bottom: 3),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Column(
                        children: [
                          purchaseFields(context, "Invoice / Memo No.",
                              purchase_controller.purimnoController),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.05,
              color: Colors.teal.shade700,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Item Details",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () async {
                        final itemDetails = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ItemDetailsScreen(),
                            //Get.to(() => const ItemDetailsScreen());
                          ),
                        );
                        if (itemDetails != null) {
                          _addItemDetails(itemDetails);
                        }
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 21,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, bottom: 1, top: 1),
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                    ),
                    children: [
                      _buildHeadingCell("Sl No."),
                      _buildHeadingCell("Item"),
                      _buildHeadingCell("Qty"),
                      _buildHeadingCell("Rate"),
                      _buildHeadingCell("Amount"),
                      _buildHeadingCell("Action"),
                    ],
                  ),
                  for (int index = 0;
                      index < purchase_controller.itemDetailsList.length;
                      index++)
                    TableRow(children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text((index + 1).toString()),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(purchase_controller
                            .itemDetailsList[index].item_name),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(formatDecimal(purchase_controller
                            .itemDetailsList[index].item_qty)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(formatDecimal(purchase_controller
                            .itemDetailsList[index].item_rate)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(formatDecimal(purchase_controller
                                    .itemDetailsList[index].item_qty *
                                purchase_controller
                                    .itemDetailsList[index].item_rate)
                            .toString()),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text("Edit"),
                        ),
                      )),
                    ])
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 16.0), // Adjust the top margin as needed
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          purchaseFields(context, "Add",
                              purchase_controller.puraddController),
                          const SizedBox(height: 10),
                          purchaseFields(context, "Ded",
                              purchase_controller.purdedController),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 45, top: 1, bottom: 1),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            formatDecimal(purchase_controller.adjustedTotal),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ]),
                  ),
                ) // netweight
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        if (validateForm()) {
                          // All required fields are valid, proceed with submission
                          purchase_controller.purdtController.text =
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(DateTime.now());
                          purchase_controller.registerAndSavePurchase();
                        } else {
                          // Display a message or alert to indicate the required fields
                          Utils.showTost(
                              msg: "Please fill all required fields.");
                        }
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
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
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Material(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashboardOfFragments()),
                          );
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget purchaseFields(
    BuildContext context, String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 1),
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        children: [
          Expanded(
            flex: 3, // Adjust the flex values as needed
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(label),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3, // Adjust the flex values as needed
            child: Align(
              alignment: Alignment.centerRight,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildHeadingCell(String text) {
  return TableCell(
    child: Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
  );
}
