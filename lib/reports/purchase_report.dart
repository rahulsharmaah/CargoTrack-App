import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/purchase_report_controller.dart';
import 'package:trans_port/model/prclass.dart';
import 'package:trans_port/model/search_ledger.dart';

class PurchaseReport extends StatefulWidget {
  const PurchaseReport({super.key});

  @override
  State<PurchaseReport> createState() => _PurchaseReportState();
}

class _PurchaseReportState extends State<PurchaseReport> {
  final report_controller = Get.put(PurchaseReportController());

  @override
  void initState() {
    super.initState();

    // Calculate the initial "from" date as 3 days before the current date
    DateTime fromDate = DateTime.now().subtract(const Duration(days: 3));
    DateTime toDate = DateTime.now();

    report_controller.fromDateController.text =
        DateFormat('yyyy-MM-dd').format(fromDate);
    report_controller.toDateController.text =
        DateFormat('yyyy-MM-dd').format(toDate);

    report_controller.getPurchaseDetails();
  }

  void resetSearch() {
    report_controller.searchController.clear();
    setState(() {
      report_controller.purchaseData =
          report_controller.originalData; // Reset to the original data
      report_controller.update();
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: report_controller.fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != report_controller.fromDate) {
      print('Selected fromDate: $picked'); // Debug print
      setState(() {
        report_controller.fromDate = picked;
        report_controller.fromDateController.text =
            DateFormat('yyyy-MM-dd').format(report_controller.fromDate);
        if (report_controller.fromDate.isAfter(report_controller.toDate)) {
          // Only update toDate if fromDate is after it
          report_controller.toDate = report_controller.fromDate;
          report_controller.toDateController.text =
              DateFormat('yyyy-MM-dd').format(report_controller.toDate);
        }
        print(
            'Calling getPurchaseDetails from $_selectFromDate: ${report_controller.fromDate}, to ${report_controller.toDate}'); // Debug print
        report_controller
            .getPurchaseDetails(); // Refresh data when from date changes
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: report_controller.toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != report_controller.toDate) {
      print('Selected toDate: $picked'); // Debug print
      setState(() {
        report_controller.toDate = picked;
        report_controller.toDateController.text =
            DateFormat('yyyy-MM-dd').format(report_controller.toDate);
        print(
            'Calling getPurchaseDetails from $_selectToDate: ${report_controller.fromDate}, to ${report_controller.toDate}'); // Debug print
        report_controller
            .getPurchaseDetails(); // Refresh data when to date changes
        report_controller.update();
      });
    }
  }

  List<PurReport> filterItems(List<PurReport> items, String searchText) {
    return items.where((item) {
      final searchQuery = searchText.toLowerCase();
      // Customize this condition based on your search criteria
      return item.purchase_customer.toLowerCase().contains(searchQuery) ||
          item.purchase_id.toString().contains(searchQuery) ||
          item.purchase_total.toLowerCase().contains(searchQuery) ||
          item.purchase_vehicleno.toLowerCase().contains(searchQuery) ||
          item.purchase_ntwt.toLowerCase().contains(searchQuery) ||
          item.purchase_date.toLowerCase().contains(searchQuery);
    }).toList();
  }

  List<DataColumn> getColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.015,
          child: const Text(
            'Pur No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12,
            
            ),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Supp Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Vec No.',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Date',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.2,
          child: const Text('Net Wt',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Total',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = screenWidth / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Purchase Report",
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
        elevation: 0.00,
        backgroundColor: Colors.greenAccent[400],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 1),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Builder(builder: (BuildContext context) {
                      return TextFormField(
                        controller: report_controller.fromDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "From Date",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () async {
                              await _selectFromDate(context);
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Builder(builder: (BuildContext context) {
                      return TextFormField(
                        controller: report_controller.toDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "To Date",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () async {
                              await _selectToDate(context);
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        String searchText = report_controller
                            .searchController.text
                            .toLowerCase();
                     setState(() {
                        report_controller.filterData(
                            searchText,
                            report_controller.fromDate,
                            report_controller.toDate);
                            

                           
                      // report_controller.purchaseData =
                      //     filterItems(report_controller.originalData, searchText);
                      report_controller.update();
                    });
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        child: Text(
                          "Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: report_controller.searchController,
                  onChanged: (text) {
                    setState(() {
                      report_controller.purchaseData =
                          filterItems(report_controller.originalData, text);
                      report_controller.update();
                    });
                  },
                  style: const TextStyle(color: Colors.lightGreen),
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        // Get.to(SearchLedger(
                        //   typedledgername:
                        //       report_controller.searchController.text,
                        // ));
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        report_controller.searchController.clear();
                        setState(() {
                          report_controller.purchaseData = report_controller
                              .originalData; // Reset to the original data
                          report_controller.update();
                        });
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .90,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: const TableBorder(
                        top: BorderSide(width: 0.1),
                        bottom: BorderSide(width: 0.3),
                      ),
                      dataRowMinHeight: 55,
                      dataRowMaxHeight: 60,
                      columns: getColumns(columnWidth),
                      rows: [
                        ...report_controller.purchaseData.map((item) {
                          return DataRow(cells: [
                            DataCell(TextButton(
                              onPressed: () {},
                              child: Text(
                                item.purchase_id.toString(),
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.green
                                    ),
                                  
                              ),
                            )),
                            DataCell(Text(item.purchase_customer)),
                            DataCell(Text(item.purchase_vehicleno)),
                            DataCell(Text(item.purchase_date)),
                            DataCell(Text(item.purchase_ntwt)),
                            DataCell(Text(item.purchase_total)),
                          ]);
                        }),
                        DataRow(
                          cells: [
                            const DataCell(Text('')), // Empty cell
                            const DataCell(Text('')), // Empty cell
                            const DataCell(Text('')), // Empty cell
                            const DataCell(Text('')),
                            const DataCell(
                              Text(
                                'Total:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ), // Empty cell
                            DataCell(
                              Text(
                                report_controller.totalSum.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
