import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/fragments/dashboard_of_fragments.dart';
import 'package:trans_port/master/party_master.dart';
//import 'package:trans_port/master/partyedit_screen.dart';
import 'package:trans_port/model/search_ledger.dart';
import 'package:trans_port/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  var searchController = TextEditingController();

  List<PartyUser> partyData = [];
  List<PartyUser> originalData = [];
  double totalSum = 0.0;

  @override
  void initState() {
    super.initState();

    getPartyLedgers();
  }

  Future<List<PartyUser>> getPartyLedgers() async {
    List<PartyUser> getPartyLedgers = [];

    try {
      var res = await http.post(Uri.parse(API.pLSearch),
      body:{
        'token': await RememberUserPrefs.sharedToken("", 1),
      }
      );

      if (res.statusCode == 200) {
        var responseBodyOfPartyLedger = jsonDecode(res.body);
        if (responseBodyOfPartyLedger["success"] == true) {
          for (var eachRecord
              in (responseBodyOfPartyLedger["partyLedgerData"] as List)) {
            getPartyLedgers.add(PartyUser.fromJson(eachRecord));
          }
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return getPartyLedgers;
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
          width: columnWidth * 1.3,
          child: const Text(
            'Sl No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 1.4,
          child: const Text('Party Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 1.3,
          child: const Text('Party OB',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 1.15,
          child: const Text('Active',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 1.15,
          child: const Text('Action',
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
            Get.to(() => DashboardOfFragments());
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
              icon: const Icon(Icons.add_circle_outline))
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
                      // calculateTotalSum(); // Calculate the total sum when filtering
                    });
                  },
                  style: const TextStyle(color: Colors.lightGreen),
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        Get.to(SearchLedger(
                          typedledgername: searchController.text,
                        ));
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          partyData =
                              originalData; // Reset to the original data
                          // calculateTotalSum(); // Recalculate total sum after clearing
                        });
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<PartyUser>>(
                future: getPartyLedgers(),
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
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 8,
                          // Adjust the width of columns here
                          columns: getColumns(columnWidth),
                          rows: snapshot.data!.map((eachPartyLedgerRecord) {
                            return DataRow(cells: [
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text(eachPartyLedgerRecord.party_id
                                      .toString()),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text(eachPartyLedgerRecord.party_name),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Text(eachPartyLedgerRecord.party_ob),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child:
                                      Text(eachPartyLedgerRecord.party_active),
                                ),
                              ),
                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red[
                                          400], // Set your desired background color here
                                      borderRadius: BorderRadius.circular(
                                          8.0), // Set your desired border radius here
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Get.to(PartyMasterScreen(
                                          partyUser: eachPartyLedgerRecord,
                                        ));
                                      },
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontSize: 14,
                                          // decoration: TextDecoration.underline,
                                          color: Colors
                                              .white, // Set your desired text color here
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]);
                          }).toList(),
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
