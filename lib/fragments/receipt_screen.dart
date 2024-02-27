import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/receipt_controller.dart';
import 'package:trans_port/fragments/dashboard_of_fragments.dart';
import 'package:trans_port/model/cashbankclass.dart';
import 'package:trans_port/model/user.dart';
import 'package:trans_port/userPreferences/current_user.dart';
import 'package:trans_port/utils/Utils.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  var formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final receipt_controller = Get.put(ReceiptController());

  @override
  void initState() {
    super.initState();
    _loadUserData();

    receipt_controller.recdt =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  _loadUserData() async {
    await _currentUser.getUserInfo();
    setState(() {
      receipt_controller.reccreatedbyController.text =
          _currentUser.user?.user_id.toString() ?? '';
    }); // Trigger a state update to re-render the UI
  }

  bool validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false; // Validation failed
    }
    if (receipt_controller.recLedger == null ||
        receipt_controller.selectedCustomer == null ||
        receipt_controller.recamountController.text.isEmpty) {
      return false; // Missing required fields
    }
    return true; // Validation passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            " New RECEIPT",
            style: TextStyle(
              fontSize: 24,
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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
                            DateFormat('yyyy-MM-dd')
                                .format(receipt_controller.recdate),
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
                              initialDate: receipt_controller.recdate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                receipt_controller.recdate = pickedDate;
                                receipt_controller.recdateController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                receipt_controller.recdtController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                receipt_controller.update();
                              });
                            } else {
                              setState(() {
                                receipt_controller.recdate =
                                    DateTime.now(); // Set the default value
                                receipt_controller.recdateController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(receipt_controller.recdate);
                                receipt_controller.recdtController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(receipt_controller.recdate);
                                receipt_controller.update();
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
                  const EdgeInsets.only(left: 35, right: 37, top: 1, bottom: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Ledger Type : "),
                  DropdownButton(
                    value: receipt_controller.recLedger,
                    hint: const Text("   Select Ledger   "),
                    items: const [
                      DropdownMenuItem(value: "Income", child: Text("Income")),
                      DropdownMenuItem(value: "Loan", child: Text("Loan")),
                      DropdownMenuItem(
                          value: "Interest", child: Text("Interest")),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          receipt_controller.recLedger = value;
                          receipt_controller.recledgerController.text = value;
                          receipt_controller.update();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FutureBuilder<List<CashBank>>(
                future: receipt_controller.getCashBank(),
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
                            const Text("Bank / Cash "),
                            DropdownButton<String>(
                              value: receipt_controller.selectedCashBank,
                              hint: const Text("Select Bank/Cash"),
                              items:
                                  snapshot.data!.map((eachPartyLedgerRecord) {
                                return DropdownMenuItem<String>(
                                  value: eachPartyLedgerRecord.cb_name,
                                  child: Text(eachPartyLedgerRecord.cb_name),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    receipt_controller.selectedCashBank = value;
                                    receipt_controller
                                        .reccashbankController.text = value;
                                    // partyOS = snapshot.data!
                                    //     .firstWhere((party) =>
                                    // party.cb_name == value)
                                    //     .cb_ob;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        // if (partyOS != null)
                        //   Column(
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //           MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             const Padding(
                        //               padding: EdgeInsets.only(left: 30.0),
                        //               child:
                        //               Text("Outstanding Balance :  Rs. "),
                        //             ),
                        //             Text(
                        //               "$partyOS",
                        //               style: const TextStyle(
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 18,
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                      ],
                    );
                  }
                },
              ),
            ),
            // Outstanding Balance Dropdown
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: FutureBuilder<List<PartyUser>>(
                future: receipt_controller.getPartyLedgers(),
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
                            const Text("Customer "),
                            DropdownButton<String>(
                              value: receipt_controller.selectedCustomer,
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
                                    receipt_controller.selectedCustomer = value;
                                    receipt_controller
                                        .reccustomerController.text = value;
                                    receipt_controller.partyOS = snapshot.data!
                                        .firstWhere((party) =>
                                            party.party_name == value)
                                        .party_ob;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        if (receipt_controller.partyOS != null)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 1.0),
                                      child:
                                          Text("Outstanding Balance :  Rs. "),
                                    ),
                                    Text(
                                      "${receipt_controller.partyOS}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
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
              padding: const EdgeInsets.only(
                  left: 20, right: 1, top: 10, bottom: 10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Column(
                        children: [
                          receiptFields(context, "Amount",
                              receipt_controller.recamountController),
                          const SizedBox(
                            height: 10,
                          ),
                          receiptFields(context, "Notes",
                              receipt_controller.recnotesController),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
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
                          receipt_controller.recdtController.text =
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(DateTime.now());
                          receipt_controller.registerAndSaveReceipt();
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
                  const SizedBox(height: 15),
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

Widget receiptFields(
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
