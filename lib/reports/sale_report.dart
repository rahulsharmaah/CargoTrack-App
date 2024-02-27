import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/sale_report_controller.dart';
import 'package:trans_port/model/srclass.dart';
import 'package:trans_port/model/search_ledger.dart';

class SaleReport extends StatefulWidget {
  const SaleReport({super.key});

  @override
  State<SaleReport> createState() => _SaleReportState();
}

class _SaleReportState extends State<SaleReport> {
  final sale_report = Get.put(SaleReportController());

  @override
  void initState() {
    super.initState();

    // Calculate the initial "from" date as 3 days before the current date
    sale_report.fromDate = sale_report.toDate.subtract(const Duration(days: 3));
    sale_report.toDate = DateTime.now();

    sale_report.fromDateController.text =
        DateFormat('yyyy-MM-dd').format(sale_report.fromDate);
    sale_report.toDateController.text =
        DateFormat('yyyy-MM-dd').format(sale_report.toDate);

    sale_report.getSaleDetails();
  }

  void filterData(
      String searchText, DateTime selectedFromDate, DateTime selectedToDate) {
    setState(() {
      sale_report.saleData = sale_report.originalData.where((item) {
        final saleDate = DateTime.parse(item.sale_date);
        final searchQuery = searchText.toLowerCase();

        bool isWithinDateRange = saleDate.isAtSameMomentAs(selectedFromDate) ||
            saleDate.isAtSameMomentAs(selectedToDate) ||
            (saleDate.isAfter(selectedFromDate) &&
                saleDate.isBefore(selectedToDate));

        return isWithinDateRange &&
            (item.sale_customer.toLowerCase().contains(searchQuery) ||
                item.sale_id.toString().contains(searchQuery) ||
                item.sale_total.toLowerCase().contains(searchQuery) ||
                item.sale_vehicleno.toLowerCase().contains(searchQuery) ||
                item.sale_ntwt.toLowerCase().contains(searchQuery) ||
                item.sale_date.toLowerCase().contains(searchQuery));
      }).toList();
      sale_report.calculateTotalSum();
      sale_report.update();
    });
  }

  void resetSearch() {
    sale_report.searchController.clear();
    setState(() {
      sale_report.saleData =
          sale_report.originalData; // Reset to the original data
      sale_report.update();
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: sale_report.fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != sale_report.fromDate) {
      setState(() {
        sale_report.fromDate = picked;
        sale_report.fromDateController.text =
            DateFormat('yyyy-MM-dd').format(sale_report.fromDate);
        if (sale_report.fromDate.isAfter(sale_report.toDate)) {
          sale_report.toDate = sale_report.fromDate;
          sale_report.toDateController.text =
              DateFormat('yyyy-MM-dd').format(sale_report.toDate);
        }
        sale_report.getSaleDetails();
        sale_report.update();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: sale_report.toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != sale_report.toDate) {
      setState(() {
        sale_report.toDate = picked;
        sale_report.toDateController.text =
            DateFormat('yyyy-MM-dd').format(sale_report.toDate);
        sale_report.getSaleDetails();
        sale_report.update();
      });
    }
  }

  List<SalReport> filterItems(List<SalReport> items, String searchText) {
    return items.where((item) {
      final searchQuery = searchText.toLowerCase();
      return item.sale_customer.toLowerCase().contains(searchQuery) ||
          item.sale_id.toString().contains(searchQuery) ||
          item.sale_total.toLowerCase().contains(searchQuery) ||
          item.sale_vehicleno.toLowerCase().contains(searchQuery) ||
          item.sale_ntwt.toLowerCase().contains(searchQuery) ||
          item.sale_date.toLowerCase().contains(searchQuery);
    }).toList();
  }

  List<DataColumn> getColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text(
            'Sal No.',
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 12),
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
          "Sale Report",
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
        backgroundColor: Colors.yellow,
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
                          controller: sale_report.fromDateController,
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
                          controller: sale_report.toDateController,
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
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        String searchText =
                            sale_report.searchController.text.toLowerCase();
                             setState(() {
                        filterData(searchText, sale_report.fromDate,
                            sale_report.toDate);
                        
                      // sale_report.saleData =
                      //     filterItems(sale_report.originalData, searchText);
                      // sale_report
                      //     .calculateTotalSum(); // Calculate the total sum when filtering
                      sale_report.update();
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
                  controller: sale_report.searchController,
                  onChanged: (text) {
                    setState(() {
                      sale_report.saleData =
                          filterItems(sale_report.originalData, text);
                      sale_report
                          .calculateTotalSum(); // Calculate the total sum when filtering
                      sale_report.update();
                    });
                  },
                  style: const TextStyle(color: Colors.lightGreen),
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        // Get.to(SearchLedger(
                        //   typedledgername: sale_report.searchController.text,
                        // ));
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        sale_report.searchController.clear();
                        setState(() {
                          sale_report.saleData = sale_report
                              .originalData; // Reset to the original data
                          sale_report
                              .calculateTotalSum(); // Recalculate total sum after clearing
                          sale_report.update();
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
                        ...sale_report.saleData.map((item) {
                          return DataRow(cells: [
                            DataCell(TextButton(
                              onPressed: () {},
                              child: Text(
                                item.sale_id.toString(),
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.orange),
                              ),
                            )),
                            DataCell(Text(item.sale_customer)),
                            DataCell(Text(item.sale_vehicleno)),
                            DataCell(Text(item.sale_date)),
                            DataCell(Text(item.sale_ntwt)),
                            DataCell(Text(item.sale_total)),
                          ]);
                        }),
                        DataRow(
                          cells: [
                            const DataCell(Text('')), // Empty cell
                            const DataCell(Text('')),
                            // Empty cell
                            const DataCell(Text('')), // Empty cell
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
                                sale_report.totalSum.toStringAsFixed(2),
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
