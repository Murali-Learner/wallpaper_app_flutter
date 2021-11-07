// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallpaper_app/screens/homeScreen.dart';
import 'package:wallpaper_app/screens/methds/firestoreData.dart';
import 'package:wallpaper_app/screens/methds/google.dart';
import 'package:wallpaper_app/screens/sharedPrefs.dart';

class UserScreen extends StatefulWidget {
  String userID;
  UserScreen({
    @required this.userID,
  });
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  static var response = GoogleClass.signInGoogle();

  @override
  var userId;
  void initState() {
    print(widget.userID);
    // FirestoreData.readUser();

    // super.initState();
    // userId = GoogleClass.uid;
  }

  @override
  Widget build(BuildContext context) {
    bool themeDark = false;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User", style: TextStyle(fontSize: 25)),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn _googleSignIn = GoogleSignIn();
                bool _isSigned = await _googleSignIn.isSignedIn();

                print(_isSigned);

                if (_isSigned) {
                  SharedPrefs.init().then((value) {
                    value.clear();
                    print(value);
                  });
                  await _googleSignIn.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ),
                  );
                } else {
                  print("user login");
                }
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Container(
        height: _height * 0.8,
        child: FutureBuilder(
            future: FirestoreData.getUserData(widget.userID),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            top: _height * 0.1,
                          ),
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                              snapshot.data.get("photoUrl"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.04,
                        ),
                        Container(
                          child: Text(
                            snapshot.data.get("displayName"),
                            style: TextStyle(color: Colors.black, fontSize: 30),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.04,
                        ),
                        Container(
                          width: _width,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextButton(
                            onPressed: () {
                              print("textbutton");
                            },
                            child: Text(
                              "Favourites",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _height * 0.04,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Theme",
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    themeDark
                                        ? Icons.dark_mode
                                        : Icons.light_mode_outlined,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        )
                      ],
                    )
                  : CircularProgressIndicator();
            }),
      ),
    );
  }
}

//  body: Container(
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: EdgeInsets.only(
//                 top: _height * 0.1,
//               ),
//               alignment: Alignment.topCenter,
//               child: CircleAvatar(
//                 radius: 70,
//               ),
//             ),
//             SizedBox(
//               height: _height * 0.04,
//             ),
//             Container(
//               child: Text(
//                 "username",
//                 style: TextStyle(color: Colors.black, fontSize: 30),
//               ),
//             ),
//             SizedBox(
//               height: _height * 0.04,
//             ),
//             Container(
//               width: _width,
//               decoration: BoxDecoration(
//                   color: Colors.black26,
//                   borderRadius: BorderRadius.circular(10)),
//               padding: EdgeInsets.only(left: 20, right: 20),
//               child: TextButton(
//                 onPressed: () {
//                   print("textbutton");
//                 },
//                 child: Text(
//                   "Favourites",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: _height * 0.04,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   color: Colors.black26,
//                   borderRadius: BorderRadius.circular(10)),
//               padding: EdgeInsets.only(left: 20, right: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Theme",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   IconButton(
//                       onPressed: () {},
//                       icon: Icon(
//                         themeDark ? Icons.dark_mode : Icons.light_mode_outlined,
//                         color: Colors.white,
//                       ))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
