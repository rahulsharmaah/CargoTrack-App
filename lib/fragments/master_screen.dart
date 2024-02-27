import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/authentication/user_screen.dart';
import 'package:trans_port/master/cashbank_master.dart';
import 'package:trans_port/master/cashbank_screen.dart';
import 'package:trans_port/master/item_screen.dart';
import 'package:trans_port/master/party_master.dart';
import 'package:trans_port/userPreferences/current_user.dart';

import '../master/parties_screen.dart';

class MasterScreen extends StatefulWidget {
  // final double totalSum;
  // final int vehicleCount;
  //
  // MasterScreen({required this.totalSum, required this.vehicleCount});

  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: (){
        //     Get.to(() => DashboardOfFragments());
        //   },
        // ),
        title: const Text(
          "MASTERS",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 5),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        toolbarOpacity: 1.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        backgroundColor: Colors.greenAccent[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(25),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(25)),
                            height: 50,
                            width: 50,
                            child: Image.asset('images/party.png'),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(() => const PartyScreen());
                              },
                              child: const Text(
                                "Parties",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                ),
                              ))
                        ],
                      ),
                      const Divider(
                        height: 25,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(25)),
                            height: 50,
                            width: 50,
                            child: Image.asset('images/loanledger.jpg'),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Loan Ledgers",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                ),
                              ))
                        ],
                      ),
                      const Divider(
                        height: 25,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(25)),
                            height: 50,
                            width: 50,
                            child: Image.asset('images/items.png'),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(() => const ItemMasterScreen());
                              },
                              child: const Text(
                                "Items",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                ),
                              ))
                        ],
                      ),

                      const Divider(
                        height: 25,
                        color: Colors.black,
                      ),

                      _currentUser.isAdminOrManager()
                          ? Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade300,
                                      borderRadius: BorderRadius.circular(25)),
                                  height: 50,
                                  width: 50,
                                  child: Image.asset('images/users.jpg'),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Get.to(() => const UserScreen());
                                    },
                                    child: const Text(
                                      "Users",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        letterSpacing: 0.3,
                                      ),
                                    ))
                              ],
                            )
                          : Container(),

                      _currentUser.isAdminOrManager()
                          ? const Divider(
                              height: 25,
                              color: Colors.black,
                            )
                          : Container(),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(25)),
                            height: 50,
                            width: 50,
                            child: Image.asset('images/paymode.png'),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          TextButton(
                              onPressed: () {
                                Get.to(const CashBankScreen());
                              },
                              child: const Text(
                                "Bank & Cash",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 0.3,
                                ),
                              )),
                        ],
                      ),
                      const Divider(
                        height: 25,
                        color: Colors.black,
                      ),
                      // const SizedBox(
                      //   height: 19,
                      // ),
                      // TextButton(
                      //   onPressed: ()
                      //   {
                      //     Get.to(() => DashboardOfFragments());
                      //   },
                      //   child:
                      //   const Text(
                      //     "Back",
                      //     style: TextStyle(
                      //       fontSize: 28,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white,
                      //       letterSpacing: 1.5,
                      //       backgroundColor: Colors.black,
                      //
                      //     ),
                      //
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: HomeFragmentScreen(
      //     totalSum: 0.0, //totalSum,
      //     vehicleCount: 0,//vehicleCount,
      //     // totalAmount: totalAmount,
      //   ),
      // ),
    );
  }
}
