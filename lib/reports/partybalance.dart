import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/fragments/report_screen.dart';
import 'package:trans_port/master/party_master.dart';
import 'package:trans_port/model/prclass.dart';
import 'package:trans_port/model/search_ledger.dart';
import 'package:trans_port/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/reports/partyBalanceDetails.dart';
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class PartyBalance extends StatefulWidget {
  const PartyBalance({super.key});

  @override
  State<PartyBalance> createState() => _PartyBalanceState();
}

class _PartyBalanceState extends State<PartyBalance> {
  var searchController = TextEditingController();
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  List<PartyUser> partyData = [];
  List<PartyUser> originalData = [];
  List<PurReport> purchaseData = [];
  List<PurReport> originalPurData = [];
  double totalSum = 0.0;
  int slno = 1;
  double totalPurchaseValue = 0.0;
  int party_id = 0;
  Map<int, double> partyTotals = {};

  @override
  void initState() {
    super.initState();
    getPartyLedgers();
    //fetchPartyTotals().then((_) => getPartyLedgers());
    //getPurchaseDetails(fromDate, toDate, party_id);
  }

  Future<void> fetchPartyTotals() async {
    for (var party in originalData) {
      double total = await fetchTotalPurchaseValue(party.party_id);
      partyTotals[party.party_id] = total;
    }
  }

  Future<List<PartyUser>> getPartyLedgers() async {
    slno = 1;
    List<PartyUser> getPartyLedgers = [];

    try {
      var res = await http.post(Uri.parse(API.clBalance), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });
      print(res.body);
      if (res.statusCode == 200) {
        print("response 200");
        var responseBodyOfPartyLedger = jsonDecode(res.body);
        //print("res.body ${responseBodyOfPartyLedger}");
        if (responseBodyOfPartyLedger["success"] == true) {
          for (var eachRecord
              in (responseBodyOfPartyLedger["partyLedgerData"] as List)) {
            print("eachrecord ${eachRecord['party_id']}");
            getPartyLedgers.add(PartyUser.fromJson({
              'party_id': eachRecord['party_id'].toString(),
              'party_name': eachRecord['party_name'].toString(),
              'party_ob': eachRecord['closingBalance'].toString(),
              'party_active': eachRecord['party_active'].toString(),
            }));
            print("eachrecord ${eachRecord['party_name']}");
            if (eachRecord['party_id'].toString().isNotEmpty) {
              fetchTotalPurchaseValue(int.parse(eachRecord['party_id']))
                  .then((value) {
                setState(() {
                  partyTotals[int.parse(eachRecord['party_id'])] = value;
                });
              });
            }
          }
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error here: $errorMsg");
    }

    setState(() {
      originalData = getPartyLedgers;
      partyData = originalData;
    });

    return getPartyLedgers;
  }

  Future<double> fetchTotalPurchaseValue(int partyId) async {
    double totalPurchaseValue = 0.0;

    try {
      var response = await http.post(Uri.parse(API.purRepDisplay), body: {
        'partyId': partyId.toString(),
        'token': await RememberUserPrefs.sharedToken("", 1),
      });

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody["success"] == true) {
          var purchaseData = responseBody["purchaseData"];
          if (purchaseData is List) {
            for (var purchaseRecord in purchaseData) {
              var purchaseValue = purchaseRecord['purchaseValue'];
              if (purchaseValue is double) {
                totalPurchaseValue += purchaseValue;
              }
            }
          }
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error: $errorMsg");
    }

    return totalPurchaseValue;
  }

  void filterData(String searchText) {
    setState(() {
      partyData = originalData.where((item) {
        final searchQuery = searchText.toLowerCase();
        return item.party_name.toLowerCase().contains(searchQuery) ||
            item.party_ob.toString().contains(searchQuery) ||
            item.party_active.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  List<PartyUser> filterItems(List<PartyUser> items, String searchText) {
    final searchQuery = searchText.toLowerCase();
    return items.where((item) {
      return item.party_name.toLowerCase().contains(searchQuery) ||
          item.party_ob.toString().contains(searchQuery) ||
          item.party_active.toLowerCase().contains(searchQuery);
    }).toList();
  }

  void calculateTotalSum() {
    totalSum = purchaseData.fold(
        0.0, (sum, item) => sum + double.parse(item.purchase_total));
  }

  Future<void> getPurchaseDetails(
      DateTime selectedFromDate, DateTime selectedToDate, int partyId) async {
    try {
      var formattedFromDate = DateFormat('yyyy-MM-dd').format(selectedFromDate);
      var formattedToDate = DateFormat('yyyy-MM-dd').format(selectedToDate);

      var res = await http.post(Uri.parse(API.purRepDisplay), body: {
        'partyId': partyId.toString(),
        'fromDate': DateFormat('yyyy-MM-dd').format(selectedFromDate),
        'toDate': DateFormat('yyyy-MM-dd').format(selectedToDate),
        'token': await RememberUserPrefs.sharedToken("", 1),

        // Pass the party ID to filter by party
      });

      if (res.statusCode == 200) {
        var responseBodyOfPurchaseReport = jsonDecode(res.body);
        if (responseBodyOfPurchaseReport["success"] == true) {
          List<PurReport> data =
              (responseBodyOfPurchaseReport["purchaseReportData"] as List)
                  .map((eachRecord) {
            return PurReport.fromJson(eachRecord);
          }).toList();

          double total = data.fold(
              0.0, (sum, item) => sum + double.parse(item.purchase_total));
          partyTotals[partyId] = total;
          setState(() {
            partyTotals[partyId] = total;
            totalSum = total;
          });
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error: $errorMsg");
    }
  }

  void resetSearch() {
    searchController.clear();
    setState(() {
      partyData = originalData;
    });
  }

  List<DataColumn> getColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.5,
          child: const Text(
            'S No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 2,
          child: const Text('Party',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 2,
          child: const Text('Closing\nBalance',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = screenWidth / 4;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => const ReportScreen());
          },
        ),
        title: const Text(
          "Parties",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
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
              Get.to(const PartyMasterScreen());
            },
            icon: const Icon(Icons.add_circle_outline),
          )
        ],
        elevation: 0.00,
        backgroundColor: Colors.blueAccent.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (text) {
                    setState(() {
                      partyData = filterItems(originalData, text);
                    });
                  },
                  style: const TextStyle(color: Colors.lightGreen),
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
                      iconSize: 18,
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          partyData = originalData;
                        });
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Expanded(
                    child: DataTable(
                      columnSpacing: 4,
                      columns: getColumns(columnWidth),
                      dataRowMinHeight: 55,
                      dataRowMaxHeight: 60,
                      rows: partyData.map((eachPartyLedgerRecord) {
                        return DataRow(cells: [
                          DataCell(
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Text(
                                  eachPartyLedgerRecord.party_id.toString()),
                            ),
                          ),
                          DataCell(
                            Padding(
                              padding: EdgeInsets.zero,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => PartyBalanceDetails(
                                        partyUser: eachPartyLedgerRecord,
                                      ));
                                },
                                child: Text(
                                  eachPartyLedgerRecord.party_name,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(eachPartyLedgerRecord.party_ob),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
