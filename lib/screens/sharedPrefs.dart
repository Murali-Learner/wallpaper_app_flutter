// @dart=2.9
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static setIdData(userId) async {
    String user = userId;
    _preferences.setString("uId", user);
    print("data: $user");
  }

  // static savedUserData(favData) async {
  //   String fav = favData;
  //   _preferences.setString("favData", favData);
  // }

  static getData() async {
    String user = _preferences.getString("uId");
    print("userData: $user");
    if (user == null) {
      return null;
    }
    return user;
  }
}
