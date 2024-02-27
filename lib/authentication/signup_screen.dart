import 'dart:convert';
import 'package:trans_port/api_connection/api_connection.dart';
import 'package:trans_port/authentication/user_screen.dart';
import 'package:trans_port/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();

  String userLevel = "user";

  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();
  var userLevelController = TextEditingController();

  var isObsecure = true.obs;

  validateUserMobile() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateMobile),
        body: {
          'user_mobile': mobileController.text.trim(),
          // 'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );

      if (res.statusCode == 200) {
        // print("Response Body of Validate Mobile: ${res.body}");
        var resBodyOfValidateMobile = jsonDecode(res.body);

        if (resBodyOfValidateMobile['mobileFound'] == true) {
          Utils.showTost(msg: "User Already Exists");
        } else {
          registerAndSaveUserRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
    }
  }

  registerAndSaveUserRecord() async {
    User userModel = User(
      1,
      nameController.text.trim(),
      mobileController.text.trim(),
      passwordController.text.trim(),
      userLevelController.text.trim(),
    );
    userModel.user_level = userLevel;
    try {
      var res = await http.post(
        Uri.parse(API.signup),
        body: userModel.toJson(),
      );
      if (res.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(res.body);
        if (resBodyOfSignUp['success'] == true) {
          Utils.showTost(msg: "User Created Successfully.");
          setState(() {
            nameController.clear();
            mobileController.clear();
            passwordController.clear();
            //userLevelController.clear();
          });
        } else {
          Utils.showTost(msg: "Error in Signing, Try Again");
        }
      }
    } catch (e) {
      print(e.toString());

      Utils.showTost(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    userLevel = "user"; // Set the default value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: cons.maxHeight),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: Image.asset("images/logo.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(
                          Radius.circular(70),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 9,
                            color: Colors.black26,
                            offset: Offset(0, -3),
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 9),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 21,
                                ),
                                TextFormField(
                                  controller: nameController,
                                  validator: (val) =>
                                      val == "" ? "User Name" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                    hintText: "User Name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        )),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    contentPadding: const EdgeInsets.all(18.0),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                TextFormField(
                                  controller: mobileController,
                                  validator: (val) =>
                                      val == "" ? "Mobile No." : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.mobile_screen_share_outlined,
                                      color: Colors.black,
                                    ),
                                    hintText: "Mobile No.",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        )),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )),
                                    contentPadding: const EdgeInsets.all(18.0),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                Obx(() => TextFormField(
                                      controller: passwordController,
                                      obscureText: isObsecure.value,
                                      validator: (val) => val == ""
                                          ? "Please enter Password"
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.vpn_key_sharp,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: Obx(() => GestureDetector(
                                              onTap: () {
                                                isObsecure.value =
                                                    !isObsecure.value;
                                              },
                                              child: Icon(
                                                isObsecure.value
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: Colors.black,
                                              ),
                                            )),
                                        hintText: "Password",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )),
                                        disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            )),
                                        contentPadding:
                                            const EdgeInsets.all(18.0),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    spacing: 15,
                                    alignment: WrapAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: RadioListTile(
                                          title: const Text("User",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          value: "user",
                                          groupValue: userLevel,
                                          onChanged: (value) {
                                            setState(() {
                                              userLevel = value.toString();
                                              userLevelController.text =
                                                  userLevel;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        child: RadioListTile(
                                          title: const Text(
                                            "Manager",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          value: "manager",
                                          groupValue: userLevel,
                                          onChanged: (value) {
                                            setState(() {
                                              userLevel = value.toString();
                                              userLevelController.text =
                                                  userLevel;
                                            });
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        validateUserMobile();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 28,
                                      ),
                                      child: Text(
                                        "Create User",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Material(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => const UserScreen());
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 24,
                                        ),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
