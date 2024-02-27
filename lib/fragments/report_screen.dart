import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/master/cashbank_master.dart';
import 'package:trans_port/reports/partybalance.dart';
import 'package:trans_port/reports/payment_report.dart';
import 'package:trans_port/reports/purchase_report.dart';
import 'package:trans_port/reports/receipt_report.dart';
import 'package:trans_port/reports/sale_report.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 110),
            alignment: Alignment.bottomCenter,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF00C853),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "REPORTS",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                "REGISTERS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade100,
                      ),
                      child: IconButton(
                        icon: Image.asset('images/purchase2.png'),
                        iconSize: 37,
                        onPressed: () {
                          Get.to(() => const PurchaseReport());
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const PurchaseReport());
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Purchase",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade100,
                      ),
                      child: IconButton(
                        icon: Image.asset('images/sales3.png'),
                        iconSize: 37,
                        onPressed: () {
                          Get.to(const SaleReport());
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const SaleReport());
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Sales",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade100,
                      ),
                      child: IconButton(
                        icon: Image.asset('images/reciept1.jpg'),
                        iconSize: 50,
                        onPressed: () {
                          Get.to(const ReceiptReport());
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const ReceiptReport());
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Receipts",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey.shade100,
                      ),
                      child: IconButton(
                        icon: Image.asset('images/payment1.jpg'),
                        iconSize: 37,
                        onPressed: () {
                          Get.to(const PaymentReport());
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const PaymentReport());
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Payment",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: 25,
            color: Colors.black,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "REPORTS",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    height: 80,
                    width: 80,
                    child: IconButton(
                      icon: Image.asset('images/party.png'),
                      iconSize: 37,
                      onPressed: () {
                        Get.to(() => const PartyBalance());
                      },
                    ),
                  ),
                  // child: Image.asset('images/party.png'),
                  // ),

                  TextButton(
                    onPressed: () {
                      Get.to(() => const PartyBalance());
                    },
                    child: const Text(
                      "Party Balance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade100,
                    ),
                    child: IconButton(
                      icon: Image.asset('images/reciept2.jpg',
                          width: 50, height: 50),
                      onPressed: () {
                        Get.to(() => const CashBankScreen());
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const CashBankScreen());
                    },
                    child: const Text(
                      "Cash & Bank",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(
            height: 25,
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  width: 50,
                  child: Image.asset('images/paymode.png'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Income & Expenses",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  width: 50,
                  child: Image.asset('images/reciept1.jpg'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Loans",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  width: 50,
                  child: Image.asset('images/interest.png'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Interest",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
