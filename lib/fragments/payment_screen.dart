import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/payment_controller.dart';
import 'package:trans_port/fragments/dashboard_of_fragments.dart';

import 'package:trans_port/model/cashbankclass.dart';

import 'package:trans_port/model/user.dart';
import 'package:trans_port/userPreferences/current_user.dart';
import 'package:trans_port/utils/Utils.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final payment_controller = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();
    _loadUserData();

    payment_controller.paydt =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    // cashBank = "cash";
    // paycashbankController.text = cashBank;
  }

  _loadUserData() async {
    await _currentUser.getUserInfo();
    setState(() {
      payment_controller.paycreatedbyController.text =
          _currentUser.user?.user_id.toString() ?? '';
      payment_controller.update();
    }); // Trigger a state update to re-render the UI
  }

  bool validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false; // Validation failed
    }
    if (payment_controller.payLedger == null ||
        payment_controller.selectedCustomer == null ||
        payment_controller.selectedCashBank == null ||
        payment_controller.payamountController.text.isEmpty) {
      return false; // Missing required fields
    }
    return true; // Validation passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey,
        title: const Center(
          child: Text(
            " New PAYMENT",
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
                                .format(payment_controller.paydate),
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
                              initialDate: payment_controller.paydate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                payment_controller.paydate = pickedDate;
                                payment_controller.paydateController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                payment_controller.paydtController.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                payment_controller.update();
                              });
                            } else {
                              setState(() {
                                payment_controller.paydate =
                                    DateTime.now(); // Set the default value
                                payment_controller.paydateController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(payment_controller.paydate);
                                payment_controller.paydtController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(payment_controller.paydate);
                                payment_controller.update();
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
                  const EdgeInsets.only(left: 35, right: 35, top: 1, bottom: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Ledger Type : "),
                  DropdownButton(
                    value: payment_controller.payLedger,
                    hint: const Text("Select Ledger"),
                    items: const [
                      DropdownMenuItem(
                          value: "Expences", child: Text("Expences")),
                      DropdownMenuItem(value: "Loan", child: Text("Loan")),
                      DropdownMenuItem(
                          value: "Interest", child: Text("Interest")),
                    ],
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          payment_controller.payLedger = value;
                          payment_controller.payledgerController.text = value;
                          payment_controller.update();
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
                future: payment_controller.getCashBank(),
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
                              value: payment_controller.selectedCashBank,
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
                                    payment_controller.selectedCashBank = value;
                                    payment_controller
                                        .paycashbankController.text = value;
                                    // partyOS = snapshot.data!
                                    //     .firstWhere((party) =>
                                    // party.cb_name == value)
                                    //     .cb_ob;
                                    payment_controller.update();
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
                future: payment_controller.getPartyLedgers(),
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
                              value: payment_controller.selectedCustomer,
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
                                    // payment_controller.payuid =
                                    payment_controller.selectedCustomer = value;
                                    payment_controller
                                        .paycustomerController.text = value;
                                    payment_controller.partyOS = snapshot.data!
                                        .firstWhere((party) =>
                                            party.party_name == value)
                                        .party_ob;
                                    payment_controller.payuid = snapshot.data!
                                        .firstWhere((party) =>
                                            party.party_name == value)
                                        .party_id;
                                    payment_controller.update();
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        if (payment_controller.partyOS != null)
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
                                      "${payment_controller.partyOS}",
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
                          paymentFields(context, "Amount",
                              payment_controller.payamountController),
                          const SizedBox(
                            height: 10,
                          ),
                          paymentFields(context, "Ref",
                              payment_controller.payrefController),
                          const SizedBox(
                            height: 10,
                          ),
                          paymentFields(context, "Notes",
                              payment_controller.paynotesController),
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
                          payment_controller.paydtController.text =
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(DateTime.now());
                          payment_controller.registerAndSavePayment();
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

Widget paymentFields(
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
