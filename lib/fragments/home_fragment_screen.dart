import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/controllers/payment_report_controller.dart';
import 'package:trans_port/controllers/purchase_report_controller.dart';
import 'package:trans_port/controllers/receipt_report_controller.dart';
import 'package:trans_port/controllers/sale_report_controller.dart';
import 'package:trans_port/reports/payment_report.dart';
import 'package:trans_port/reports/receipt_report.dart';
import 'package:trans_port/widgets/dashbord_card.dart';
import 'dart:math' as math;
import '../api_connection/api_connection.dart';
import 'package:http/http.dart' as http;

class HomeFragmentScreen extends StatefulWidget {
  const HomeFragmentScreen({super.key});

  //var totalAmount;
  // final int vehicleCount;
  //
  // HomeFragmentScreen({required this.totalSum, required this.vehicleCount});
  //const HomeFragmentScreen({Key? key}) : super(key: key);

  @override
  State<HomeFragmentScreen> createState() => _HomeFragmentScreenState();
}

class _HomeFragmentScreenState extends State<HomeFragmentScreen> {
  final payment_controller = Get.put(PaymentReportController());
  final receipt_controller = Get.put(ReceiptReportController());
  final purchase_controller = Get.put(PurchaseReportController());
  final sale_controller = Get.put(SaleReportController());
  final purchase_text_style = TextStyle(
      fontSize: 16, color: Colors.blue.shade800, fontWeight: FontWeight.bold);
  final sale_text_style = TextStyle(
      fontSize: 16, color: Colors.green.shade800, fontWeight: FontWeight.bold);
  final payment_text_style = TextStyle(
      fontSize: 16,
      color: Colors.lightGreen.shade800,
      fontWeight: FontWeight.bold);

  @override
  void initState() {
    // TODO: implement initState
    payment_controller.getPaymentDetails();
    receipt_controller.getReceiptDetails();
    purchase_controller.getPurchaseDetails();
    sale_controller.getSaleDetails();
    getPartyLedgers("getSalesForParty", "2");
    getPartyLedgers("getReceiptsForParty", "2");
    getPartyLedgers("getPurchasesForParty", "2");
    getPartyLedgers("getPaymentsForParty", "2");
    getPartyLedgers("calculateClosingBalance", "2");
  }

  Future<void> getPartyLedgers(String func, String partyId) async {
    try {
      var res1 = await http.post(Uri.parse(API.clBalance),
          body: <String, String>{"function": func, "party_id": partyId});
      print("function: $func: ${res1.body}");
    } catch (errorMsg) {
      print("Error: $errorMsg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.green,
        title: const Text(
          'DASHBOARD',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(color: Colors.blue.shade50),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: const Text(
                    "Purchase Last 5 Days",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GetBuilder<PurchaseReportController>(builder: (controller) {
                      return Column(
                        children: [
                          const Text("Total Vehicles",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                          SizedBox(height: Get.height * 0.01),
                          dashbord_card(
                              child: Text(
                                controller.lastfiveDayVehicle.toString(),
                                style: purchase_text_style,
                              ),
                              backgroundColor: Colors.blue.shade100,
                              strokeColor: Colors.blue.shade700,
                              borderRadius: 10,
                              dot: true),
                          SizedBox(height: Get.height * 0.01),
                          Text(
                            '${controller.lastfiveDayWeight.toStringAsFixed(2)} Kgs', // Display the totalAmount here
                            style: purchase_text_style,
                          )
                        ],
                      );
                    }),
                    Column(
                      children: [
                        const Text("Rate Required",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )),
                        SizedBox(height: Get.height * 0.01),
                        dashbord_card(
                            child: Text(
                              "0",
                              style: purchase_text_style,
                            ),
                            backgroundColor: Colors.blue.shade100,
                            strokeColor: Colors.white,
                            borderRadius: 10,
                            dot: false),
                        SizedBox(height: Get.height * 0.01),
                        Text(
                          '0.00 Kgs', // Display the totalAmount here
                          style: purchase_text_style,
                        ),
                      ],
                    ),
                    GetBuilder<PurchaseReportController>(builder: (controller) {
                      return Column(
                        children: [
                          const Text("Rate Finalised",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                          SizedBox(height: Get.height * 0.01),
                          dashbord_card(
                              child: Text(
                                controller.lastfiveDaySum.toStringAsFixed(0),
                                style: purchase_text_style,
                              ),
                              backgroundColor: Colors.blue.shade100,
                              strokeColor: Colors.blue.shade700,
                              borderRadius: 10,
                              dot: false),
                          SizedBox(height: Get.height * 0.01),
                          Text(
                            '${controller.lastfiveDayWeight.toStringAsFixed(2)} Kgs', // Display the totalAmount here
                            style: purchase_text_style,
                          ),
                        ],
                      );
                    })
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            decoration: BoxDecoration(color: Colors.green.shade50),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Text(
                      "Sales Last 5 Days",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GetBuilder<SaleReportController>(builder: (controller) {
                        return Column(
                          children: [
                            const Text("Total \nVehicles",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )),
                            SizedBox(height: Get.height * 0.01),
                            dashbord_card(
                              child: Text(
                                controller.lastfiveDayVehicle.toString(),
                                style: sale_text_style,
                              ),
                              strokeColor: Colors.green.shade400,
                              backgroundColor: Colors.white,
                              borderRadius: 5000,
                              dot: true,
                            ),
                            SizedBox(height: Get.height * 0.01),
                            Text(
                              '${controller.lastfiveDayWeight.toStringAsFixed(2)} Kgs',
                              style: sale_text_style,
                            ),
                          ],
                        );
                      }),
                      Column(
                        children: [
                          const Text("Rate \nRequired",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                          SizedBox(height: Get.height * 0.01),
                          dashbord_card(
                            child: Text(
                              "0",
                              style: sale_text_style,
                            ),
                            backgroundColor: Colors.white,
                            strokeColor: Colors.green.shade200,
                            borderRadius: 5000,
                            dot: false,
                          ),
                          SizedBox(height: Get.height * 0.01),
                          Text(
                            '0.00 Kgs',
                            style: sale_text_style,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Final \nPending",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                          SizedBox(height: Get.height * 0.01),
                          dashbord_card(
                            child: Text(
                              "-",
                              style: sale_text_style,
                            ),
                            strokeColor: Colors.white,
                            backgroundColor: Colors.green.shade200,
                            borderRadius: 5000,
                            dot: false,
                          ),
                          SizedBox(height: Get.height * 0.01),
                          Text(
                            '0.00 Kgs',
                            style: sale_text_style,
                          ),
                        ],
                      ),
                      GetBuilder<SaleReportController>(builder: (controller) {
                        return Column(
                          children: [
                            const Text("Rate \nFinalised",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )),
                            SizedBox(height: Get.height * 0.01),
                            dashbord_card(
                              child: Text(
                                controller.lastfiveDaySale.length.toString(),
                                style: sale_text_style,
                              ),
                              backgroundColor: Colors.green.shade200,
                              strokeColor: Colors.green.shade900,
                              borderRadius: 5000,
                              dot: false,
                            ),
                            SizedBox(height: Get.height * 0.01),
                            Text(
                              '${controller.lastfiveDaySum.toStringAsFixed(2)} Rs',
                              style: sale_text_style,
                            ),
                          ],
                        );
                      })
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(color: Colors.green.shade100),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Text(
                    "Receipts & Payments - Last 5 Days",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.001),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GetBuilder<ReceiptReportController>(builder: (controller) {
                      return Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.to(const ReceiptReport());
                              },
                              child: const Text(
                                "Receipt",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )),
                          SizedBox(height: Get.height * 0.02),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationZ(
                              math.pi / 4,
                            ),
                            child: dashbord_card(
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationZ(
                                    -math.pi / 4,
                                  ),
                                  child: Text(
                                    controller.lastfiveDayReceipt.length
                                        .toString(),
                                    style: payment_text_style,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                strokeColor: Colors.green.shade500,
                                borderRadius: 0,
                                dot: false),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            "₹ ${controller.lastFiveDaySum.toStringAsFixed(2)}", // Display the totalAmount here
                            style: payment_text_style,
                          )
                        ],
                      );
                    }),
                    GetBuilder<PaymentReportController>(builder: (controller) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(const PaymentReport());
                            },
                            child: const Text("Payment",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationZ(
                              math.pi / 4,
                            ),
                            child: dashbord_card(
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationZ(
                                    -math.pi / 4,
                                  ),
                                  child: Text(
                                    controller.lastfiveDayPayment.length
                                        .toString(),
                                    style: payment_text_style,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                strokeColor: Colors.green.shade500,
                                borderRadius: 0,
                                dot: false),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                              "₹ ${controller.lastFiveDaySum.toStringAsFixed(2)}", // Display the totalAmount here
                              style: payment_text_style)
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
