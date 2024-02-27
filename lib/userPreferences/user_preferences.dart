import 'dart:convert';
import 'package:trans_port/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs {
  // static get userInfo => null;

  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  static Future<User?> readUserInfo() async {
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;
  }

  static Future<void> removeUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }

  static Future<String?> sharedToken(String? token, int type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (type == 1) {
      String? userToken = preferences.getString("userToken");
      return userToken;
    } else if (token.toString().isNotEmpty) {
      preferences.setString("userToken", token!);
      print("from shared prefrences: $token");
    }
    return token;
  }
}
