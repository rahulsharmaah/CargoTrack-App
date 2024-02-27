import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/receipt_report_controller.dart';
import 'package:trans_port/model/rpclass.dart';
import 'package:trans_port/model/search_ledger.dart';

class ReceiptReport extends StatefulWidget {
  const ReceiptReport({super.key});

  @override
  State<ReceiptReport> createState() => _ReceiptReportState();
}

class _ReceiptReportState extends State<ReceiptReport> {
  final receipt_controller = Get.put(ReceiptReportController());
  @override
  void initState() {
    super.initState();

    // Calculate the initial "from" date as 3 days before the current date
    DateTime fromDate = DateTime.now().subtract(const Duration(days: 3));
    DateTime toDate = DateTime.now();

    receipt_controller.fromDateController.text =
        DateFormat('yyyy-MM-dd').format(fromDate);
    receipt_controller.toDateController.text =
        DateFormat('yyyy-MM-dd').format(toDate);

    receipt_controller.getReceiptDetails();
  }

  // void calculateTotalSum() {
  //   totalSum = receiptData.fold(0.0, (sum, item) => sum + double.parse(item.receipt_amount));
  // }

  void resetSearch() {
    receipt_controller.searchController.clear();
    setState(() {
      receipt_controller.receiptData =
          receipt_controller.originalData; // Reset to the original data
      receipt_controller.update();
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: receipt_controller.fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != receipt_controller.fromDate) {
      setState(() {
        receipt_controller.fromDate = picked;
        receipt_controller.fromDateController.text =
            DateFormat('yyyy-MM-dd').format(receipt_controller.fromDate);
        if (receipt_controller.fromDate.isAfter(receipt_controller.toDate)) {
          receipt_controller.toDate = receipt_controller.fromDate;
          receipt_controller.toDateController.text =
              DateFormat('yyyy-MM-dd').format(receipt_controller.toDate);
        }
        receipt_controller.getReceiptDetails();
        receipt_controller.update();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: receipt_controller.toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != receipt_controller.toDate) {
      setState(() {
        receipt_controller.toDate = picked;
        receipt_controller.toDateController.text =
            DateFormat('yyyy-MM-dd').format(receipt_controller.toDate);
        receipt_controller.getReceiptDetails();
        receipt_controller.update();
      });
    }
  }

  List<RecUser> filterItems(List<RecUser> items, String searchText) {
    return items.where((item) {
      final searchQuery = searchText.toLowerCase();
      return item.receipt_customer.toLowerCase().contains(searchQuery) ||
          item.receipt_id.toString().contains(searchQuery) ||
          item.receipt_amount.toLowerCase().contains(searchQuery) ||
          item.receipt_cb.toLowerCase().contains(searchQuery) ||
          item.receipt_ledger.toLowerCase().contains(searchQuery) ||
          item.receipt_date.toLowerCase().contains(searchQuery);
    }).toList();
  }

  List<DataColumn> getColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text(
            'Rec No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Cust Name',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.3,
          child: const Text('Amount',
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
          child: const Text('Ledger',
              overflow: TextOverflow.visible, style: TextStyle(fontSize: 12)),
        ),
        numeric: true,
      ),
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text('Pay Mode',
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
          "Receipt Report",
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
        backgroundColor: Colors.blueAccent.shade100,
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
                    child: Builder(
                      builder: (BuildContext context) {
                        return TextFormField(
                          controller: receipt_controller.fromDateController,
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
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Builder(
                      builder: (BuildContext context) {
                        return TextFormField(
                          controller: receipt_controller.toDateController,
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
                      },
                    ),
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
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        String searchText = receipt_controller
                            .searchController.text
                            .toLowerCase();
                        setState(() {
                          receipt_controller.filterData(
                              searchText,
                              receipt_controller.fromDate,
                              receipt_controller.toDate);

                          // receipt_controller.receiptData =
                          //     filterItems(receipt_controller.originalData, searchText);
                          // receipt_controller
                          //     .calculateTotalSum(); // Calculate the total sum when filtering
                          receipt_controller.update();
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
                            color: Colors.black,
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
                  controller: receipt_controller.searchController,
                  onChanged: (text) {
                    setState(() {
                      receipt_controller.receiptData =
                          filterItems(receipt_controller.originalData, text);
                      receipt_controller
                          .calculateTotalSum(); // Calculate the total sum when filtering
                      receipt_controller.update();
                    });
                  },
                  style: const TextStyle(color: Colors.lightGreen),
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        // Get.to(SearchLedger(
                        //   typedledgername:
                        //       receipt_controller.searchController.text,
                        // ));
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        receipt_controller.searchController.clear();
                        setState(() {
                          receipt_controller.receiptData = receipt_controller
                              .originalData; // Reset to the original data
                          receipt_controller
                              .calculateTotalSum(); // Recalculate total sum after clearing
                          receipt_controller.update();
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
                  width: MediaQuery.of(context).size.width * 0.9,
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
                        ...receipt_controller.receiptData.map((item) {
                          return DataRow(cells: [
                            DataCell(TextButton(
                              onPressed: () {},
                              child: Text(
                                item.receipt_id.toString(),
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue),
                              ),
                            )),
                            DataCell(Text(item.receipt_customer)),
                            DataCell(Text(item.receipt_amount)),
                            DataCell(Text(item.receipt_date)),
                            DataCell(Text(item.receipt_ledger)),
                            DataCell(Text(item.receipt_cb)),
                          ]);
                        }),
                        DataRow(
                          cells: [
                            const DataCell(Text('')),
                            const DataCell(
                              Text(
                                'Total:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            /// Empty cell
                            DataCell(
                              Text(
                                receipt_controller.totalSum.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ), // Empty cell
                            const DataCell(Text('')),
                            // Empty cell
                            const DataCell(Text('')), // Empty cell
                            const DataCell(Text('')),
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
