import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_wallpaper_app/methods/firestore_data.dart';
import 'package:my_wallpaper_app/methods/google_auth.dart';
import 'package:my_wallpaper_app/screens/shared_prefs.dart';

import 'user_info.dart';
import 'wallpaper_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  String userID = "";
  @override
  void initState() {
    SharedPrefs.getData().then((uid) {
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Map<String, String> categories = {
      "Nature":
          "https://images.unsplash.com/photo-1520962922320-2038eebab146?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
      "Technology":
          "https://images.unsplash.com/photo-1535223289827-42f1e9919769?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTR8fHRlY2hub2xvZ3l8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "Beach":
          "https://plus.unsplash.com/premium_photo-1658506878350-f598c139f804?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8N3x8YmVhY2h8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "city":
          "https://images.unsplash.com/photo-1543872084-c7bd3822856f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8Y2l0eXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      "Cars":
          "https://images.unsplash.com/photo-1525609004556-c46c7d6cf023?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y2Fyc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      "Books":
          "https://images.unsplash.com/photo-1535905557558-afc4877a26fc?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Ym9va3N8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "Love":
          "https://images.unsplash.com/photo-1426543881949-cbd9a76740a4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGxvdmV8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "Pets":
          "https://images.unsplash.com/photo-1604848698030-c434ba08ece1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjR8fHBldHN8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
      "Space":
          "https://images.unsplash.com/photo-1484589065579-248aad0d8b13?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fHNwYWNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
      "Weapons":
          "https://images.unsplash.com/photo-1595590424283-b8f17842773f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8d2VhcG9uc3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    };

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        actions: [
          userID == ""
              ? IconButton(
                  padding: EdgeInsets.only(right: 10),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });

                    var response = await GoogleClass.signInGoogle();

                    await FirestoreData.addUserData(
                      response["email"],
                      response["uid"],
                      response["name"],
                      response["photoUrl"],
                    );

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
                      print(height);
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
                            snapshot.data?.get("photoUrl"),
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
        title: Text(
          'Categories',
          style: GoogleFonts.sourceSansPro(
              fontSize: 30, fontWeight: FontWeight.w600),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: height * 0.88,
                  width: width,
                  child: Stack(
                    children: [
                      GestureDetector(
                        child: Container(
                          // padding: EdgeInsets.all(20),
                          child: GridView.builder(
                              reverse: false,
                              itemCount: categories.keys.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                    bottom: 7,
                                    right: 8,
                                  ),
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
                                        height: height * 0.1,
                                        // padding: EdgeInsets.all(30),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(categories
                                                  .values
                                                  .elementAt(index)),
                                              fit: BoxFit.cover,
                                              scale: 1),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 1.5,
                                              sigmaY: 1.5,
                                              tileMode: TileMode.clamp,
                                            ),
                                            child: Text(
                                              categories.keys.elementAt(index),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.donegalOne(
                                                  fontSize: 35,
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
      ),
    );
  }
}
