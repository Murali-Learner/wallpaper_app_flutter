// @dart=2.9

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallpaper_app/screens/login.dart';
import 'package:wallpaper_app/screens/methds/firestoreData.dart';
import 'package:wallpaper_app/screens/methds/google.dart';
import 'package:wallpaper_app/screens/sharedPrefs.dart';
import 'package:wallpaper_app/screens/userInfo.dart';
import 'package:wallpaper_app/screens/wallpaperScreen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String userID = "";
  @override
  void initState() {
    SharedPrefs.getData().then((uid) {
      print(uid);
      setState(() {
        if (uid == null) {
          userID = "";
        } else {
          userID = uid;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    Map<String, String> categories = {
      "Nature": "images/nature.jpeg",
      "Technology": "images/technology.jpeg",
      "Beach": "images/beach.jpeg",
      "Birds": "images/bird.jpeg",
      "Cars": "images/cars.jpeg",
      "Books": "images/books.jpeg",
      "Love": "images/love.jpeg",
      "Pets": "images/pets.jpeg",
      "Space": "images/space.jpeg",
      "Weapons": "images/weapon.jpeg",
    };

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        actions: [
          // Container(
          //     decoration:
          //         BoxDecoration(borderRadius: BorderRadius.circular(10)),
          //     child:
          //         Image(image: NetworkImage(GoogleClass.photoId, scale: 0.5))),
          userID == ""
              ? IconButton(
                  padding: EdgeInsets.only(right: 10),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    // if (userData == null) {
                    var response = await GoogleClass.signInGoogle();
                    print(response);
                    // var isExisted =
                    //     await FirestoreData.isTokenExists(response["uid"]);
                    // print(isExisted);
                    // if (!isExisted) {
                    await FirestoreData.addUserData(
                      response["email"],
                      response["uid"],
                      response["name"],
                      response["photoUrl"],
                    );
                    // }
                    SharedPrefs.setIdData(response["uid"]);
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return UserScreen(
                          userID: response["uid"],
                        );
                      },
                    ));
                  },
                  // },
                  icon: Icon(
                    Icons.person,
                    size: 35,
                  ))
              : FutureBuilder<DocumentSnapshot>(
                  future: FirestoreData.getUserData(userID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return UserScreen(
                                userID: userID,
                              );
                            },
                          ));
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data.get("photoUrl"),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: Container(),
                      );
                    }
                  },
                )
        ],
        backgroundColor: Color.fromRGBO(27, 25, 50, 1),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Categories'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: _height * 0.89,
                width: _width,
                child: Stack(
                  children: [
                    GestureDetector(
                      child: Container(
                        // padding: EdgeInsets.all(20),
                        child: GridView.builder(
                            itemCount: categories.keys.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.only(bottom: 10, right: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return Wallpaper(
                                            category: categories.keys
                                                .elementAt(index));
                                      },
                                    ));
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: _height * 0.1,
                                      // padding: EdgeInsets.all(30),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(categories.values
                                                .elementAt(index)),
                                            fit: BoxFit.cover,
                                            scale: 1),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 1.2,
                                            sigmaY: 1.3,
                                            tileMode: TileMode.clamp,
                                          ),
                                          child: Text(
                                            categories.keys.elementAt(index),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}