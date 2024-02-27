import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/master/parties_screen.dart';


class SearchLedger extends StatefulWidget {
 // const SearchLedger({Key? key}) : super(key: key);
  final String? typedledgername;

  const SearchLedger({super.key, this.typedledgername});

  @override
  State<SearchLedger> createState() => _SearchLedgerState();
}

class _SearchLedgerState extends State<SearchLedger> {

  TextEditingController searchController = TextEditingController();

  @override
  void initState()
  {
    super.initState();

    searchController.text = widget.typedledgername!;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
            //  Get.to(SearchItems(typedKeyWords:searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.purpleAccent,
            ),
          ),
          hintText: "Search...",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          suffixIcon: IconButton(
            onPressed: ()
            {
              Get.to(const PartyScreen());
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.purpleAccent,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.purpleAccent,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.purpleAccent,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.yellow,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
