import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/master/cashbank_screen.dart';
import 'package:trans_port/model/cashbankclass.dart';
import 'package:trans_port/model/search_ledger.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class CashBankScreen extends StatefulWidget {
  const CashBankScreen({super.key});

  @override
  State<CashBankScreen> createState() => _CashBankScreenState();
}

class _CashBankScreenState extends State<CashBankScreen> {
  var searchController = TextEditingController();

  Future<List<CashBank>> getCbName() async {
    List<CashBank> getCbName = [];

    try {
      var res = await http.post(Uri.parse(API.cbSearch), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCbName = jsonDecode(res.body);
        if (responseBodyOfCbName["success"] == true) {
          for (var eachRecord in (responseBodyOfCbName["cbNameData"] as List)) {
            getCbName.add(CashBank.fromJson(eachRecord));
          }
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return getCbName;
  }

  List<CashBank> filteredList = [];
  List<CashBank> originalList = []; // Add this line to your existing code

  List<CashBank> filterCashBankList(
      List<CashBank> originalList, String searchText) {
    if (searchText.isEmpty) {
      return originalList;
    }

    final String lowercaseSearch = searchText.toLowerCase();

    List<CashBank> filteredList = originalList.where((item) {
      return item.cb_name.toLowerCase().contains(lowercaseSearch);
    }).toList();

    return filteredList;
  }

  void updateFilteredList() {
    setState(() {
      // Use the filterCashBankList method to update the filtered list
      filteredList = filterCashBankList(originalList, searchController.text);
    });
  }

  List<DataColumn> getColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text(
            'Sl No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.4,
          child: const Text('Date',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.4,
          child: const Text('Bank / Cash',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.4,
          child: const Text('Bank/Cash OB',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.4,
          child: const Text('Active',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Action',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = screenWidth / 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BANK & CASH",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CashBankMasterScreen());
            },
            tooltip: "Bank or Cash",
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
          ),
        ],
        elevation: 0.00,
        backgroundColor: Colors.greenAccent[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width * 0.90,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.lightGreen),
                  onChanged: (text) {
                    // Call the method to update the filtered list
                    updateFilteredList();
                  },
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        // Get.to(SearchLedger(
                        //   typedledgername: searchController.text,
                        // ));
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          filteredList.clear();
                        });
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<CashBank>>(
                future: getCbName(),
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
                    originalList = snapshot.data!;
                    List<DataRow> dataRows = (filteredList.isNotEmpty
                            ? filteredList
                            : originalList)
                        .asMap()
                        .map((index, item) {
                          int slNo = index + 1;
                          return MapEntry(
                            index,
                            DataRow(cells: [
                              DataCell(Text(slNo.toString())),
                              DataCell(Text(item.cb_date)),
                              DataCell(Text(item.cb_name)),
                              DataCell(Text(item.cb_ob)),
                              DataCell(Text(item.cb_active)),
                              DataCell(
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Get.to(() => const CashBankMasterScreen(
                                          // typedledgername:
                                          //     searchController.text,
                                          ));
                                    },
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          );
                        })
                        .values
                        .toList();
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        // Add the 'child' property here
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          border: const TableBorder(
                            top: BorderSide(width: 0.5),
                            bottom: BorderSide(width: 0.3),
                          ),
                          dataRowMinHeight: 55,
                          dataRowMaxHeight: 60,
                          columns: getColumns(columnWidth),
                          rows: dataRows,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
