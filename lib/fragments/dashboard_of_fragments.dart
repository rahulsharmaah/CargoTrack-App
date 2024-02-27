import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:trans_port/fragments/master_screen.dart';
import 'package:trans_port/fragments/payment_screen.dart';
import 'package:trans_port/fragments/profile_fragment_screen.dart';
import 'package:trans_port/fragments/purchase_screen.dart';
import 'package:trans_port/fragments/receipt_screen.dart';
import 'package:trans_port/fragments/report_screen.dart';

import 'package:trans_port/fragments/sales_screen.dart';

import '../userPreferences/current_user.dart';
import 'home_fragment_screen.dart';

class DashboardOfFragments extends StatelessWidget {
  CurrentUser rememberCurrentUser = Get.put(CurrentUser());
  final List<Widget> _fragmentScreens = [
    const HomeFragmentScreen(),
    const PurchaseScreen(),
    const SaleScreen(),
    const PaymentScreen(),
    const ReceiptScreen(),
    const MasterScreen(),
    const ReportScreen(),
    const ProfileFragmentScreen(),
  ];

  final List _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "DashBoard"
    },
    {
      "active_icon": Icons.add,
      "non_active_icon": Icons.add_circle_outline,
      "label": "Purchase",
    },
    {
      "active_icon": FontAwesomeIcons.bucket,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Sales"
    },
    {
      "active_icon": Icons.payment,
      "non_active_icon": Icons.payment_outlined,
      "label": "Payments",
    },
    {
      "active_icon": Icons.receipt,
      "non_active_icon": Icons.receipt_long_outlined,
      "label": "Receipt",
    },
    {
      "active_icon": Icons.list,
      "non_active_icon": Icons.list_outlined,
      "label": "Masters",
    },
    {
      "active_icon": Icons.report,
      "non_active_icon": Icons.report_off_outlined,
      "label": "Reports",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline_outlined,
      "label": "Profile",
    },
  ];

  final RxInt _indexNumber = 0.obs;

  DashboardOfFragments({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          // rememberCurrentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Obx(() => _fragmentScreens[_indexNumber.value]),
            ),
            bottomNavigationBar: Obx(() => BottomNavigationBar(
                  currentIndex: _indexNumber.value,
                  onTap: (value) {
                    _indexNumber.value = value;
                  },
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.white70,
                  selectedFontSize: 12,
                  unselectedFontSize: 9,
                  items: List.generate(8, (index) {
                    var navBtnProperty = _navigationButtonsProperties[index];
                    return BottomNavigationBarItem(
                      backgroundColor: Colors.green.shade300,
                      icon: Icon(
                        navBtnProperty["non_active_icon"],
                        size: 15,
                      ),
                      activeIcon: Icon(
                        navBtnProperty["active_icon"],
                        size: 15,
                      ),
                      label: navBtnProperty["label"],
                    );
                  }),
                )),
          );
        });
  }
}
