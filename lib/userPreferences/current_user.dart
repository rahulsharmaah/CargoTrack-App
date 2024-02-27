import 'package:trans_port/model/user.dart';
import 'package:get/get.dart';
import 'package:trans_port/userPreferences/user_preferences.dart';

class CurrentUser extends GetxController
{
  final Rx<User?> _currentUser = User(0,'','','','').obs;

  User? get user => _currentUser.value;

  getUserInfo() async
  {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
   bool isAdminOrManager() {
    return user?.user_level == 'admin' || user?.user_level == 'manager'  ? true : false;
  }
}