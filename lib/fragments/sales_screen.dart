import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/sale_controller.dart';
import 'package:trans_port/fragments/dashboard_of_fragments.dart';
import 'package:trans_port/master/itemdetails_screen.dart';
import 'package:trans_port/model/user.dart';
import 'package:trans_port/userPreferences/current_user.dart';
import 'package:trans_port/utils/Utils.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  var formKey = GlobalKey<FormState>();
  var formKey1 = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var formKey3 = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final sale_controller = Get.put(SaleController());

  @override
  void initState() {
    super.initState();
    _loadUserData();

    sale_controller.saledt =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    sale_controller.salelgwtController.addListener(() {
      sale_controller.calculateNetWeight();
      sale_controller.update();
      setState(() {});
    });

    sale_controller.saleugwtController.addListener(() {
      sale_controller.calculateNetWeight();
      sale_controller.update();
      setState(() {});
    });

    sale_controller.saleaddController.addListener(() {
      sale_controller.addValue =
          double.tryParse(sale_controller.saleaddController.text) ?? 0.0;
      sale_controller.calculateAdjustedTotal();
      sale_controller.update();
    });
    sale_controller.saleugwtController.addListener(() {
      sale_controller.netWeightLU =
          double.tryParse(sale_controller.saleugwtController.text) ?? 0.0;
      sale_controller.calculateNetWeight();
      sale_controller.update();
    });

    sale_controller.salededController.addListener(() {
      sale_controller.dedValue =
          double.tryParse(sale_controller.salededController.text) ?? 0.0;
      sale_controller.calculateAdjustedTotal();
      sale_controller.update();
    });

    sale_controller.calculateAdjustedTotal();
    sale_controller.update();
  }

  _loadUserData() async {
    await _currentUser.getUserInfo();
    setState(() {
      sale_controller.salecreatedbyController.text =
          _currentUser.user?.user_id.toString() ?? '';
      sale_controller.update();
    });
  }

  bool validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false; // Validation failed
    }
    if (sale_controller.selectedCustomer == null) {
      return false; // Missing required fields
    }
    return true; // Validation passed
  }

  // List to store item details

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "New SALE",
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
                  const EdgeInsets.only(left: 18, right: 45, top: 1, bottom: 1),
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
                                .format(sale_controller.saledate),
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
                              initialDate: sale_controller.saledate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                sale_controller.saledate = pickedDate;
                                sale_controller.saledateController.text =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);
                                sale_controller.saledtController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            } else {
                              setState(() {
                                sale_controller.saledate =
                                    DateTime.now(); // Set the default value
                                sale_controller.saledateController.text =
                                    DateFormat('dd/MM/yyyy')
                                        .format(sale_controller.saledate);
                                sale_controller.saledtController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(sale_controller.saledate);
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
                future: sale_controller.getPartyLedgers(),
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
                              value: sale_controller.selectedCustomer,
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
                                    sale_controller.selectedCustomer = value;
                                    sale_controller
                                        .salecustomerController.text = value;
                                    sale_controller.partyOS = snapshot.data!
                                        .firstWhere((party) =>
                                            party.party_name == value)
                                        .party_ob;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        if (sale_controller.partyOS != null)
                          GetBuilder<SaleController>(builder: (salecontroller) {
                            return Column(
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
                                        "${salecontroller.partyOS}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                      ],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 45, top: 1, bottom: 1),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Column(
                        children: [
                          purchaseFields(context, "Vehicle No.",
                              sale_controller.salevehiclenoController),
                          const SizedBox(
                            height: 5,
                          ),
                          purchaseFields(context, "Loading Wt",
                              sale_controller.salelgwtController),
                          const SizedBox(
                            height: 5,
                          ),
                          purchaseFields(context, "Unloading Wt",
                              sale_controller.saleugwtController),
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
                      left: 40, right: 75, top: 1, bottom: 1),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Net Weight"),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            sale_controller
                                .formatDecimal(sale_controller.salenetweight),
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
                  const EdgeInsets.only(left: 18, right: 45, top: 1, bottom: 3),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Column(
                        children: [
                          purchaseFields(context, "Invoice / Memo No.",
                              sale_controller.saleimnoController),
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
                          sale_controller.addItemDetails(itemDetails);
                          setState(() {});
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
                      index < sale_controller.itemDetailsList.length;
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
                        child: Text(
                            sale_controller.itemDetailsList[index].item_name),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(sale_controller.formatDecimal(
                            sale_controller.itemDetailsList[index].item_qty)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(sale_controller.formatDecimal(
                            sale_controller.itemDetailsList[index].item_rate)),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(sale_controller
                            .formatDecimal(sale_controller
                                    .itemDetailsList[index].item_qty *
                                sale_controller
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
              margin: const EdgeInsets.only(
                  top: 16.0), // Adjust the top margin as needed
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
                              sale_controller.saleaddController),
                          const SizedBox(height: 10),
                          purchaseFields(context, "Ded",
                              sale_controller.salededController),
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
                            sale_controller
                                .formatDecimal(sale_controller.adjustedTotal),
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
                          sale_controller.saledtController.text =
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(DateTime.now());
                          sale_controller.registerAndSaveSale();
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
                  const SizedBox(height: 10),
                  Material(
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
