import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_port/controllers/party_report_controller.dart';
import 'package:trans_port/model/srclass.dart';
import 'package:trans_port/model/search_ledger.dart';
import 'package:trans_port/model/user.dart';

class PartyBalanceDetails extends StatefulWidget {
  const PartyBalanceDetails({super.key, required this.partyUser});
  final PartyUser partyUser;

  @override
  State<PartyBalanceDetails> createState() => _PartyBalanceDetailsState();
}

class _PartyBalanceDetailsState extends State<PartyBalanceDetails> {
  final party_report = Get.put(PartyReportController());
  late Double salesamount;

  @override
  void initState() {
    super.initState();
    party_report.fromDate =
        party_report.toDate.subtract(const Duration(days: 7));
    party_report.toDate = DateTime.now();

    party_report.fromDateController.text =
        DateFormat('dd-MM-yyyy').format(party_report.fromDate);
    party_report.toDateController.text =
        DateFormat('dd-MM-yyyy').format(party_report.toDate);
    party_report.getSaleDetails(partyId: widget.partyUser.party_id.toString());
    party_report.getPaymentDetails(
        partyId: widget.partyUser.party_id.toString());
    party_report.getPurchaseDetails(
      partyId: widget.partyUser.party_id.toString(),
    );
    party_report.getReceiptDetails(
      partyId: widget.partyUser.party_id.toString(),
    );
    party_report.getPartyDetailsById(
        partyId: widget.partyUser.party_id.toString(),
        fun: 'openingBalance',
        selectedFromDate: party_report.fromDateController.text,
        selectedToDate: party_report.toDateController.text);
    party_report.getPartyDetailsById(
        partyId: widget.partyUser.party_id.toString(),
        fun: 'getSalesForParty',
        selectedFromDate: party_report.fromDateController.text,
        selectedToDate: party_report.toDateController.text);
    party_report.getPartyDetailsById(
        partyId: widget.partyUser.party_id.toString(),
        fun: 'getPurchasesForParty',
        selectedFromDate: party_report.fromDateController.text,
        selectedToDate: party_report.toDateController.text);
    party_report.getPartyDetailsById(
        partyId: widget.partyUser.party_id.toString(),
        fun: 'calculateClosingBalance',
        selectedFromDate: party_report.fromDateController.text,
        selectedToDate: party_report.toDateController.text);

    party_report.getPartyDetailsById(
        partyId: widget.partyUser.party_id.toString(),
        fun: 'getPaymentsForParty',
        selectedFromDate: party_report.fromDateController.text,
        selectedToDate: party_report.toDateController.text);
    party_report.getPartyDetailsById(
        partyId: widget.partyUser.party_id.toString(),
        fun: 'getReceiptsForParty',
        selectedFromDate: party_report.fromDateController.text,
        selectedToDate: party_report.toDateController.text);
  
    Future.delayed(
        const Duration(seconds: 1),
        () => filterData(
              party_report.searchController.text.toLowerCase(),
              party_report.fromDate,
              party_report.toDate,
            ));
  }

  void filterData(
      String searchText, DateTime selectedFromDate, DateTime selectedToDate) {
    setState(() {
      party_report.salesaleData = party_report.saleoriginalData.where((item) {
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
      party_report.calculateTotalSum();
    });
  }

  void resetSearch() {
    party_report.searchController.clear();
    setState(() {
      party_report.salesaleData =
          party_report.saleoriginalData; // Reset to the original data
      party_report.update();
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: party_report.fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != party_report.fromDate) {
      setState(() {
        party_report.fromDate = picked;
        party_report.fromDateController.text =
            DateFormat('dd-MM-yyyy').format(party_report.fromDate);
        if (party_report.fromDate.isAfter(party_report.toDate)) {
          party_report.toDate = party_report.fromDate;
          party_report.toDateController.text =
              DateFormat('dd-MM-yyyy').format(party_report.toDate);
        }
        party_report.getSaleDetails(
            partyId: widget.partyUser.party_id.toString());
        party_report.getPaymentDetails(
            partyId: widget.partyUser.party_id.toString());
        party_report.getReceiptDetails(
            partyId: widget.partyUser.party_id.toString());
        party_report.getPurchaseDetails(
            partyId: widget.partyUser.party_id.toString());
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'getSalesForParty',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'getReceiptsForParty',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'getPurchaseForParty',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'getPaymentsForParty',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'calculateClosingBalance',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'openingBalance',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        // party_report.update();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: party_report.toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != party_report.toDate) {
      setState(() {
        party_report.toDate = picked;
        party_report.toDateController.text =
            DateFormat('dd-MM-yyyy').format(party_report.toDate);
        party_report.getSaleDetails(
            partyId: widget.partyUser.party_id.toString());
        party_report.getPaymentDetails(
            partyId: widget.partyUser.party_id.toString());
        party_report.getPurchaseDetails(
            partyId: widget.partyUser.party_id.toString());
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'getSalesForParty',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        // party_report.update();
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'getReceiptsForParty',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'getPurchaseForParty',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'getPaymentsForParty',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'calculateClosingBalance',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
        party_report.getPartyDetailsById(
            partyId: widget.partyUser.party_id.toString(),
            fun: 'openingBalance',
            selectedFromDate: party_report.fromDateController.text,
            selectedToDate: party_report.toDateController.text);
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = screenWidth / 4;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.partyUser.party_name,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.00,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 1),
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
                            controller: party_report.fromDateController,
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
                            controller: party_report.toDateController,
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
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          String searchText =
                              party_report.searchController.text.toLowerCase();
                          filterData(searchText, party_report.fromDate,
                              party_report.toDate);
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
              const Divider(
                thickness: 1,
                color: Colors.purple,
              ),
              GetBuilder<PartyReportController>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 28.0, right: 28, top: 3, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Opening Balance"),
                          const Spacer(
                            flex: 1,
                          ),
                          Text(controller.opningBalance.toStringAsFixed(2))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("Sales"),
                          const Spacer(
                            flex: 1,
                          ),
                          Text(
                            controller.totalSale.toStringAsFixed(2),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("Purchase"),
                          const Spacer(
                            flex: 1,
                          ),
                          Text(controller.totalPurchase.toStringAsFixed(2))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("Receipt"),
                          const Spacer(
                            flex: 1,
                          ),
                          Text(controller.totalReceipt.toStringAsFixed(2))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("Payment"),
                          const Spacer(
                            flex: 1,
                          ),
                          Text(controller.totalPayment.toStringAsFixed(2))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("Closing Balance"),
                          const Spacer(
                            flex: 1,
                          ),
                          Text(controller.closingBalance.toStringAsFixed(2))
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const Divider(
                thickness: 1,
                color: Colors.purple,
              ),
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.cyan,
                child: const Text(
                  "Sales",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
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
                        dataRowMinHeight: 15,
                        dataRowMaxHeight: 28,
                        columns: party_report.getSaleColumns(columnWidth),
                        rows: [
                          ...party_report.salesaleData.map((item) {
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
                          }).toList(),
                          DataRow(
                            cells: [
                              const DataCell(Text('')),
                              const DataCell(
                                Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataCell(
                                Text(
                                  party_report.saletotalSum.toStringAsFixed(2),
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
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.cyan,
                child: const Text(
                  "Payment",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                // height: MediaQuery.of(context).size.height,
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
                        dataRowMinHeight: 25,
                        dataRowMaxHeight: 28,
                        columns: party_report.getPaymentColumns(columnWidth),
                        rows: [
                          ...party_report.paymentpaymentData.map((item) {
                            return DataRow(cells: [
                              DataCell(TextButton(
                                onPressed: () {},
                                child: Text(
                                  item.payment_id.toString(),
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.orange),
                                ),
                              )),
                              DataCell(Text(item.payment_customer)),
                              DataCell(Text(item.payment_amount)),
                              DataCell(Text(item.payment_date)),
                              DataCell(Text(item.payment_ledger)),
                              DataCell(Text(item.payment_cb)),
                            ]);
                          }).toList(),
                          DataRow(
                            cells: [
                              const DataCell(Text('')),
                              const DataCell(
                                Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataCell(
                                Text(
                                  party_report.totalPayment.toStringAsFixed(2),
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

              //purchase
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.cyan,
                child: const Text(
                  "Purchase",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                // height: MediaQuery.of(context).size.height,
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
                        dataRowMinHeight: 20,
                        dataRowMaxHeight: 28,
                        columns: party_report.getPurchaseColumns(columnWidth),
                        rows: [
                          ...party_report.purchaseData.map((item) {
                            return DataRow(cells: [
                              DataCell(TextButton(
                                onPressed: () {},
                                child: Text(
                                  item.purchase_id.toString(),
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.orange),
                                ),
                              )),
                              DataCell(Text(item.purchase_customer)),
                              DataCell(Text(item.purchase_vehicleno)),
                              DataCell(Text(item.purchase_date)),
                              DataCell(Text(item.purchase_ntwt)),
                              DataCell(Text(item.purchase_total)),
                            ]);
                          }).toList(),
                          DataRow(
                            cells: [
                              const DataCell(Text('')),
                              const DataCell(
                                Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataCell(
                                Text(
                                  party_report.purtotalSum.toStringAsFixed(2),
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

              //Reciept
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.cyan,
                child: const Text(
                  "Reciept",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                // height: MediaQuery.of(context).size.height,
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
                        dataRowMinHeight: 20,
                        dataRowMaxHeight: 28,
                        columns: party_report.getRecieptColumns(columnWidth),
                        rows: [
                          ...party_report.receiptData.map((item) {
                            return DataRow(cells: [
                              DataCell(TextButton(
                                onPressed: () {},
                                child: Text(
                                  item.receipt_id.toString(),
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.orange),
                                ),
                              )),
                              DataCell(Text(item.receipt_customer)),
                              DataCell(Text(item.receipt_amount)),
                              DataCell(Text(item.receipt_date)),
                              DataCell(Text(item.receipt_ledger)),
                              DataCell(Text(item.receipt_cb)),
                            ]);
                          }).toList(),
                          DataRow(
                            cells: [
                              const DataCell(Text('')),
                              const DataCell(
                                Text(
                                  'Total:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataCell(
                                Text(
                                  party_report.recieptTotalSum
                                      .toStringAsFixed(2),
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
      ),
    );
  }
}
