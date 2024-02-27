import 'dart:convert';
import 'package:trans_port/api_connection/api_connection.dart';
import 'package:trans_port/master/parties_screen.dart';
import 'package:trans_port/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trans_port/userPreferences/user_preferences.dart';
import 'package:trans_port/utils/Utils.dart';

class PartyMasterScreen extends StatefulWidget {
  final PartyUser? partyUser;

  const PartyMasterScreen({super.key, this.partyUser});

  @override
  State<PartyMasterScreen> createState() => _PartyMasterScreenState();
}

class _PartyMasterScreenState extends State<PartyMasterScreen> {
  final formKey = GlobalKey<FormState>();
  final partynameController = TextEditingController();
  final partyobController = TextEditingController();
  String party_active = "active";
  PartyUser? _editedPartyUser;

  @override
  void initState() {
    super.initState();
    if (widget.partyUser != null) {
      _editedPartyUser = widget.partyUser;
      partynameController.text = _editedPartyUser!.party_name;
      partyobController.text = _editedPartyUser!.party_ob;
      party_active = _editedPartyUser!.party_active;
    }
  }

  Future<void> validatePartyName() async {
    try {
      final partyId = _editedPartyUser?.party_id ?? '';
      final res = await http.post(
        Uri.parse(API.validatePartyName),
        body: {
          'party_name': partynameController.text.trim(),
          'party_id': partyId.toString(),
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );

      if (res.statusCode == 200) {
        final resBodyOfValidatePartyName = jsonDecode(res.body);
        print("res.body ${res.body}");

        if (resBodyOfValidatePartyName['partyNameFound'] == true) {
          Utils.showTost(msg: "Party Already Exists");
        } else {
          registerAndSavePartyMaster();
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
    }
  }

  Future<void> registerAndSavePartyMaster() async {
    final userModel = PartyUser(
      widget.partyUser?.party_id ?? 0,
      partynameController.text.trim(),
      partyobController.text.trim(),
      party_active,
    );

    try {
      final res = await http.post(
        Uri.parse(API.pmCreate),
        body: {
          ...userModel.toJson(),
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );

      if (res.statusCode == 200) {
        final resBodyOfPartyMaster = jsonDecode(res.body);
        if (resBodyOfPartyMaster['success'] == true) {
          Utils.showTost(msg: "Party Created Successfully.");
          setState(() {
            partynameController.clear();
            partyobController.clear();
          });
        } else {
          Utils.showTost(msg: "Error in Creation, Try Again");
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
    }
  }

  Future<void> registerAndUpdatePartyMaster() async {
    if (_editedPartyUser == null) {
      return;
    }

    final userModel = PartyUser(
      _editedPartyUser!.party_id,
      partynameController.text.trim(),
      partyobController.text.trim(),
      party_active,
    );

    try {
      final res = await http.post(
        Uri.parse(API.pmUpdate),
        body: {
          ...userModel.toJson(),
          'token': await RememberUserPrefs.sharedToken("", 1),
        },
      );

      if (res.statusCode == 200) {
        final resBodyOfPartyMaster = jsonDecode(res.body);
        if (resBodyOfPartyMaster['success'] == true) {
          Utils.showTost(msg: "Party Updated Successfully.");
          setState(() {
            partynameController.clear();
            partyobController.clear();
          });
          Get.to(() => const PartyScreen());
        } else {
          Utils.showTost(msg: "Error in Update, Try Again");
        }
      }
    } catch (e) {
      print(e.toString());
      Utils.showTost(msg: e.toString());
    }
  }

  void validateAndSaveParty() {
    if (formKey.currentState!.validate()) {
      if (widget.partyUser != null) {
        // If you have a partyUser, it's an update operation
        registerAndUpdatePartyMaster();
      } else {
        // If you don't have a partyUser, it's a new party creation
        validatePartyName();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: cons.maxHeight),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: Image.asset("images/logo.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 9,
                          color: Colors.white70,
                          offset: Offset(0, -3),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 9),
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
                                  controller: partynameController,
                                  validator: (val) =>
                                      val == "" ? "Party Name" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                    hintText: "Party Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.purple,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(18.0),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                TextFormField(
                                  controller: partyobController,
                                  validator: (val) =>
                                      val == "" ? "Opening Balance." : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.money,
                                      color: Colors.black,
                                    ),
                                    hintText: "Opening Balance.",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.purple,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.white60,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(18.0),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                SizedBox(
                                  height: 120,
                                  width: 180,
                                  child: Column(
                                    children: [
                                      RadioListTile(
                                        title: const Text("Active"),
                                        value: "active",
                                        groupValue: party_active,
                                        onChanged: (value) {
                                          {
                                            setState(() {
                                              party_active = value.toString();
                                            });
                                          }
                                        },
                                      ),
                                      RadioListTile(
                                        title: const Text("Disable Party"),
                                        value: "disableparty",
                                        groupValue: party_active,
                                        onChanged: (value) {
                                          {
                                            setState(() {
                                              party_active = value.toString();
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Material(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.partyUser == null) {
                                        validateAndSaveParty();
                                      } else {
                                        registerAndUpdatePartyMaster();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 28,
                                      ),
                                      child: Text(
                                        widget.partyUser != null
                                            ? "Update Party"
                                            : "Create Party",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 19,
                                ),
                                Material(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => const PartyScreen());
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 28,
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
