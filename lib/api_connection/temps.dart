// Expanded(
//   child: FutureBuilder<List<PartyUser>>(
//     future: getPartyLedgers(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       } else if (snapshot.hasError) {
//         return Center(
//           child: Text("Error: ${snapshot.error}"),
//         );
//       } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//         return const Center(
//           child: Text("Empty, No Data."),
//         );
//       } else {
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             columnSpacing: 5,
//             // Adjust the width of columns here
//             columns: getColumns(columnWidth),
//             rows: snapshot.data!.map((eachPartyLedgerRecord)
//             {
//               return DataRow(cells: [
//                 DataCell(
//                   Padding(
//                     padding: EdgeInsets.zero,
//                     child: Text((slno++).toString()),
//                   ),
//                 ),
//                 DataCell(
//                   Padding(
//                     padding: EdgeInsets.zero,
//                     child: Text(eachPartyLedgerRecord.party_name),
//                   ),
//                 ),
//                 DataCell(
//                   Padding(
//                     padding: EdgeInsets.zero,
//                     child: Text(eachPartyLedgerRecord.party_ob),
//                   ),
//                 ),
//                 DataCell(
//                   FutureBuilder<double>(
//                     future: getPurchaseDetails(eachPartyLedgerRecord.party_id), // Pass the party ID
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator(); // Show a loading indicator while fetching data
//                       } else if (snapshot.hasError) {
//                         return Text('Error: ${snapshot.error}');
//                       } else {
//                         return Text(snapshot.data?.toStringAsFixed(2) ?? 'N/A'); // Display the total purchase value
//                       }
//                     },
//                   ),
//                 ),
//
//               ]);
//             }).toList(),
//           ),
//         );
//       }
//     },
//   ),
// ),



// Future<double> getTotalPurchaseValueForParty(int partyId) async {
//   double totalPurchaseValue = 0.0;
//
//   try {
//     final response = await http.post(Uri.parse(API.purRepDisplay), body: {
//       'partyId': partyId.toString(),
//     });
//
//     if (response.statusCode == 200) {
//       final responseBody = jsonDecode(response.body);
//       if (responseBody["success"] == true) {
//         final purchaseData = responseBody["purchaseData"];
//         if (purchaseData is List) {
//           for (var purchaseRecord in purchaseData) {
//             final purchaseValue = purchaseRecord['purchaseValue'];
//             if (purchaseValue is double) {
//               totalPurchaseValue += purchaseValue;
//             }
//           }
//         }
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Error, status code is not 200");
//     }
//   } catch (errorMsg) {
//     print("Error: $errorMsg");
//   }
//
//   return totalPurchaseValue;
// }

