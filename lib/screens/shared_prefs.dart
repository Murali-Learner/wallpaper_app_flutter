import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences preferences;

  static Future init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static setIdData(userId) async {
    String user = userId;
    preferences.setString("uId", user);
    print("data: $user");
  }

  // static savedUserData(favData) async {
  //   String fav = favData;
  //   _preferences.setString("favData", favData);
  // }

  static Future getData() async {
    var user = preferences.getString("uId");
    // log("userData: ${user == 'null'}");

    return user;
  }
}
