import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/master/items_master.dart';
import 'package:trans_port/model/itemclass.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class ItemMasterScreen extends StatefulWidget {
  const ItemMasterScreen({super.key});

  @override
  State<ItemMasterScreen> createState() => _ItemMasterScreenState();
}

class _ItemMasterScreenState extends State<ItemMasterScreen> {
  var searchController = TextEditingController();

  Future<List<ItemUser>> getItemName() async {
    List<ItemUser> getItemName = [];

    try {
      var res = await http.post(Uri.parse(API.iLSearch), body: {
        "search_query": searchController.text,
        'token': await RememberUserPrefs.sharedToken("", 1),
      });

      if (res.statusCode == 200) {
        var responseBodyOfItemName = jsonDecode(res.body);
        if (responseBodyOfItemName["success"] == true) {
          for (var eachRecord
              in (responseBodyOfItemName["itemNameData"] as List)) {
            getItemName.add(ItemUser.fromJson(eachRecord));
          }
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return getItemName;
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
          child: const Text('Item Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.4,
          child: const Text('Item Active',
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
          "ITEMS",
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
              Get.to(() => const ItemsMasterScreen());
            },
            tooltip: "Create Item",
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
              width: MediaQuery.of(context).size.width * 0.95,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.lightGreen),
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        // setState(
                        //     () {}); // Trigger a rebuild when search icon is pressed
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        searchController.clear();
                        setState(
                            () {}); // Trigger a rebuild when cancel icon is pressed
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ItemUser>>(
                future: getItemName(),
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
                    // Filter items by item name based on search query
                    List<ItemUser> items = snapshot.data!
                        .where((item) => item.item_name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .toList();

                    List<DataRow> dataRows = items
                        .asMap()
                        .map((index, item) {
                          int slNo = index + 1;
                          return MapEntry(
                            index,
                            DataRow(cells: [
                              DataCell(Text(slNo.toString())),
                              DataCell(Text(item.item_name)),
                              DataCell(Text(item.item_active)),
                              DataCell(TextButton(
                                onPressed: () {
                                  // Perform your action here
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[400],
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Add border radius here
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      // decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )),
                            ]),
                          );
                        })
                        .values
                        .toList();

                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              border: const TableBorder(
                                  top: BorderSide(width: 0.5),
                                  bottom: BorderSide(width: 0.3)),
                              dataRowMinHeight: 55,
                              dataRowMaxHeight: 60,
                              columns: getColumns(columnWidth),
                              rows: dataRows,
                            )),
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
