// @dart=2.9

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wallpaper_app/methds/firestoreData.dart';
import 'package:wallpaper_app/methds/google.dart';
import 'package:wallpaper_app/methds/showtoast.dart';
import 'package:wallpaper_app/screens/favimages.dart';
import 'package:wallpaper_app/screens/homeScreen.dart';

import 'package:wallpaper_app/screens/sharedPrefs.dart';
import 'package:wallpaper_app/screens/wallpaperScreen.dart';

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

  var userId;
  void initState() {
    print("////${widget.userID}");
    // FirestoreData.readUser();

    // super.initState();
    // userId = GoogleClass.uid;
  }

  @override
  Widget build(BuildContext context) {
    bool themeDark = true;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: _height,
        child: FutureBuilder(
            future: FirestoreData.getUserData(widget.userID),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            snapshot.data.get("photoUrl"),
                          ),
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8,
                          sigmaY: 8,
                          tileMode: TileMode.clamp,
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: _height * 0.1,
                              ),
                              alignment: Alignment.topCenter,
                              child: CircleAvatar(
                                onBackgroundImageError:
                                    (exception, stackTrace) {
                                  return CircularProgressIndicator();
                                },
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
                                style: GoogleFonts.alice(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600),
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
                                onPressed: () async {
                                  print(widget.userID);
                                  var favoList = await FirestoreData.getFavList(
                                      widget.userID);
                                  favoList.length != 0
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return FavImages(
                                                  favoList: favoList);
                                            },
                                          ),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return HomeScreen();
                                            },
                                          ),
                                        );
                                  favoList.length == 0
                                      ? showToast("No Favorities, Add Some..")
                                      : Container();

                                  // print(FirestoreData.getFavList(widget.userID)
                                  //     .then((value) {
                                  //   print(value);
                                  // }));
                                },
                                child: Text(
                                  "Favourites",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30,
                                  ),
                                ),
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
                                onPressed: () async {
                                  GoogleSignIn _googleSignIn = GoogleSignIn();
                                  // bool _isSigned = await _googleSignIn.isSignedIn();

                                  setState(() {
                                    SharedPrefs.preferences.clear();
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

                                  // }
                                },
                                child: Text(
                                  "Logout",
                                  style: GoogleFonts.actor(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            /* Dark Mode
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
                            ) */
                          ],
                        ),
                      ),
                    )
                  : Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
