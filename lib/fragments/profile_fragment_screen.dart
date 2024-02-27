import 'package:trans_port/authentication/login_screen.dart';
import 'package:trans_port/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_port/userPreferences/user_preferences.dart';

class ProfileFragmentScreen extends StatefulWidget {
  const ProfileFragmentScreen({super.key});


  @override
  State<ProfileFragmentScreen> createState() => _ProfileFragmentScreenState();
}

class _ProfileFragmentScreenState extends State<ProfileFragmentScreen> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async {
    var resultResponse = await Get.dialog(AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text(
        "Log Out",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: const Text("Are you Sure ?\n to exit App."),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: () {
              Get.back(result: "loggedOut");
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.black),
            ))
      ],
    )
    );
    if(resultResponse == "loggedOut")
    {
      RememberUserPrefs.removeUserInfo()
          .then((value)
      {
        Get.off(const LoginScreen());
      });

    }
  }

  Widget userInfoItemProfile(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            userData,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    await _currentUser.getUserInfo();
    setState(() {}); // Trigger a state update to re-render the UI
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.green, Colors.pinkAccent]
          )
      ),
      //color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Center(
            child: Image.asset(
              'images/logo.png',
              width: 150,
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          userInfoItemProfile(Icons.person, _currentUser.user?.user_name ?? ""),

          const SizedBox(
            height: 20,
          ),
          userInfoItemProfile(Icons.mobile_screen_share_outlined, _currentUser.user?.user_mobile ?? ""),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Material(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  signOutUser();
                },
                borderRadius: BorderRadius.circular(32),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
