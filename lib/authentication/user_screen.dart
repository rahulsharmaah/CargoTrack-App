import 'dart:convert';
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/authentication/signup_screen.dart';
import 'package:trans_port/model/search_ledger.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/model/user.dart';
import 'package:trans_port/utils/Utils.dart';

import '../api_connection/api_connection.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  var searchController = TextEditingController();

  var userNameController = TextEditingController();
  var mobileController = TextEditingController();

  List<User> userData = [];
  List<User> originalData = [];

  Future<List<User>> getUserName() async {
    List<User> getUserName = [];

    try {
      var res = await http.post(Uri.parse(API.userSearch), body: {
        'token': await RememberUserPrefs.sharedToken("", 1),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCbName = jsonDecode(res.body);
        if (responseBodyOfCbName["success"] == true) {
          for (var eachRecord
              in (responseBodyOfCbName["userNameData"] as List)) {
            getUserName.add(User.fromJson(eachRecord));
          }
        }
      } else {
        Utils.showTost(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return getUserName;
  }

  void filterData(String searchText) {
    setState(() {
      userData = originalData.where((item) {
        final searchQuery = searchText.toLowerCase();
        return item.user_name.toLowerCase().contains(searchQuery) ||
            item.user_mobile.contains(searchQuery) ||
            item.user_level.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName().then((data) {
      setState(() {
        userData = data;
        originalData = List.from(data);
      });
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
          child: const Text('User Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.4,
          child: const Text('Mobile No.',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
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
          "User List",
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
              Get.to(() => const SignUpScreen());
            },
            tooltip: "User List",
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
          ),
        ],
        elevation: 0.00,
        backgroundColor: Colors.orangeAccent[400],
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
                  onChanged: (text) {
                    filterData(text);
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
                      iconSize: 21,
                      onPressed: () {
                        searchController.clear();
                        filterData("");
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: userData.isEmpty
                  ? const Center(
                      child: Text("Empty, No Data."),
                    )
                  : SingleChildScrollView(
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
                          rows: userData
                              .asMap()
                              .map(
                                (index, item) => MapEntry(
                                  index,
                                  DataRow(cells: [
                                    DataCell(Text((index + 1).toString())),
                                    DataCell(Text(item.user_name)),
                                    DataCell(Text(item.user_mobile)),
                                    DataCell(Text(item.user_level)),
                                    DataCell(
                                      TextButton(
                                        onPressed: () {
                                          Get.to(() => const SignUpScreen());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red[400],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
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
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              )
                              .values
                              .toList(),
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
