// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/screens/homeScreen.dart';

import 'package:wallpaper_app/screens/login.dart';
import 'package:wallpaper_app/screens/sharedPrefs.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefs.init();
  await Firebase.initializeApp();
  var userData = SharedPrefs.getData();

  // print("userDataMain:$userData");
  // runApp(MyApp());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var userData = SharedPrefs.getData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
