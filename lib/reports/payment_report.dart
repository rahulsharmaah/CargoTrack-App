import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/payment_report_controller.dart';
import 'package:trans_port/model/paymasclass.dart';
import 'package:trans_port/model/search_ledger.dart';

class PaymentReport extends StatefulWidget {
  const PaymentReport({super.key});

  @override
  State<PaymentReport> createState() => _PaymentReportState();
}

class _PaymentReportState extends State<PaymentReport> {
  final payment_report = Get.put(PaymentReportController());
  @override
  void initState() {
    super.initState();

    // Calculate the initial "from" date as 3 days before the current date
    payment_report.fromDate =
        payment_report.toDate.subtract(const Duration(days: 3));
    payment_report.toDate = DateTime.now();

    payment_report.fromDateController.text =
        DateFormat('yyyy-MM-dd').format(payment_report.fromDate);
    payment_report.toDateController.text =
        DateFormat('yyyy-MM-dd').format(payment_report.toDate);

    payment_report.getPaymentDetails();
  }

  // void calculateEntriesAndTotalAmount() {
  //   numberOfEntries = paymentData.length;
  //   totalAmount = paymentData.fold(0.0, (sum, item) => sum + double.parse(item.payment_amount));
  // }

  void filterData(
      String searchText, DateTime selectedFromDate, DateTime selectedToDate) {
    setState(() {
      payment_report.paymentData = payment_report.originalData.where((item) {
        final paymentData = DateFormat("yyyy/MM/dd").parse(item.payment_date);
        final searchQuery = searchText.toLowerCase();

        bool isWithinDateRange =
            paymentData.isAtSameMomentAs(selectedFromDate) ||
                paymentData.isAtSameMomentAs(selectedToDate) ||
                (paymentData.isAfter(selectedFromDate) &&
                    paymentData.isBefore(selectedToDate));

        return isWithinDateRange &&
            (item.payment_customer.toLowerCase().contains(searchQuery) ||
                item.payment_id.toString().contains(searchQuery) ||
                item.payment_amount.toLowerCase().contains(searchQuery) ||
                item.payment_cb.toLowerCase().contains(searchQuery) ||
                item.payment_ledger.toLowerCase().contains(searchQuery) ||
                item.payment_date.toLowerCase().contains(searchQuery));
      }).toList();
      payment_report.update();
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: payment_report.fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != payment_report.fromDate) {
      setState(() {
        payment_report.fromDate = picked;
        payment_report.fromDateController.text =
            DateFormat('yyyy-MM-dd').format(payment_report.fromDate);
        if (payment_report.fromDate.isAfter(payment_report.toDate)) {
          payment_report.toDate = payment_report.fromDate;
          payment_report.toDateController.text =
              DateFormat('yyyy-MM-dd').format(payment_report.toDate);
        }
        payment_report.getPaymentDetails();
        payment_report.update();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: payment_report.toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != payment_report.toDate) {
      setState(() {
        payment_report.toDate = picked;
        payment_report.toDateController.text =
            DateFormat('yyyy-MM-dd').format(payment_report.toDate);
        payment_report.getPaymentDetails();
        payment_report.update();
      });
    }
  }

  List<PayUser> filterItems(List<PayUser> items, String searchText) {
    return items.where((item) {
      final searchQuery = searchText.toLowerCase();
      return item.payment_customer.toLowerCase().contains(searchQuery) ||
          item.payment_id.toString().contains(searchQuery) ||
          item.payment_amount.toLowerCase().contains(searchQuery) ||
          item.payment_cb.toLowerCase().contains(searchQuery) ||
          item.payment_ledger.toLowerCase().contains(searchQuery) ||
          item.payment_date.toLowerCase().contains(searchQuery);
    }).toList();
  }

  List<DataColumn> getColumns(double columnWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: columnWidth * 0.15,
          child: const Text(
            'Pay No.',
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
          "Payment Report",
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
        backgroundColor: Colors.purple.shade300,
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
                          controller: payment_report.fromDateController,
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
                          controller: payment_report.toDateController,
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
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        String searchText =
                            payment_report.searchController.text.toLowerCase();
                               setState(() {
                        filterData(searchText, payment_report.fromDate,
                            payment_report.toDate);
                      
                      // payment_report.paymentData =
                      //     filterItems(payment_report.originalData, searchText);
                      // payment_report
                      //     .calculateTotalSum(); // Calculate the total sum when filtering
                      payment_report.update();
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
                  controller: payment_report.searchController,
                  onChanged: (text) {
                    setState(() {
                      payment_report.paymentData =
                          filterItems(payment_report.originalData, text);
                      payment_report
                          .calculateTotalSum(); // Calculate the total sum when filtering
                      payment_report.update();
                    });
                  },
                  style: const TextStyle(color: Colors.lightGreen),
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      iconSize: 21,
                      onPressed: () {
                        // Get.to(SearchLedger(
                        //   typedledgername: payment_report.searchController.text,
                        // ));
                      },
                      icon: const Icon(Icons.search),
                    ),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        payment_report.searchController.clear();
                        setState(() {
                          payment_report.paymentData = payment_report
                              .originalData; // Reset to the original data
                          payment_report
                              .calculateTotalSum(); // Recalculate total sum after clearing
                          payment_report.update();
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
                        ...payment_report.paymentData.map((item) {
                          return DataRow(cells: [
                            DataCell(TextButton(
                              onPressed: () {},
                              child: Text(
                                item.payment_id.toString(),
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.purple),
                              ),
                            )),
                            DataCell(Text(item.payment_customer)),
                            DataCell(Text(item.payment_amount)),
                            DataCell(Text(item.payment_date)),
                            DataCell(Text(item.payment_ledger)),
                            DataCell(Text(item.payment_cb)),
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
                                payment_report.totalSum.toStringAsFixed(2),
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
