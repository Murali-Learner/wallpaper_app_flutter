// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallpaper_app/screens/homeScreen.dart';
import 'package:wallpaper_app/screens/methds/firestoreData.dart';
import 'package:wallpaper_app/screens/methds/google.dart';
import 'package:wallpaper_app/screens/sharedPrefs.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final currentUser = FirebaseAuth.instance.currentUser;
  @override
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: _height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool _isSigned = await _googleSignIn.isSignedIn();
                    print(_isSigned);
                    var response = await GoogleClass.signInGoogle();
                    print(response);
                    var isExisted =
                        await FirestoreData.isTokenExists(response["uid"]);
                    print(isExisted);
                    if (!isExisted) {
                      FirestoreData.addUserData(
                        response["email"],
                        response["uid"],
                        response["name"],
                        response["photoUrl"],
                      );
                    }

                    // print(response["name"]);
                    // // shared
                    SharedPrefs.setIdData(response["uid"]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ),
                    );
                  },
                  child: Text("Signin With Google"),
                ),
                // SizedBox(
                //   height: _height * 0.02,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
