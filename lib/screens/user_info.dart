import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_wallpaper_app/methods/firestore_data.dart';
import 'package:my_wallpaper_app/methods/show_toast.dart';
import 'package:my_wallpaper_app/screens/fav_images_screen.dart';
import 'package:my_wallpaper_app/screens/home_screen.dart';
import 'package:my_wallpaper_app/screens/shared_prefs.dart';
import '../methods/google_auth.dart';

class UserScreen extends StatefulWidget {
  String userID;
  UserScreen({
    required this.userID,
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(""),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        alignment: Alignment.center,
        height: height,
        child: FutureBuilder(
            future: FirestoreData.getUserData(widget.userID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        snapshot.data?.get("photoUrl"),
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
                            top: height * 0.1,
                          ),
                          alignment: Alignment.topCenter,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                              snapshot.data?.get("photoUrl"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Text(
                          snapshot.data!.get("displayName"),
                          style: GoogleFonts.alice(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextButton(
                            onPressed: () async {
                              print(widget.userID);
                              var favoList =
                                  await FirestoreData.getFavList(widget.userID);
                              favoList.length != 0
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return FavImages(favList: favoList);
                                        },
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const HomeScreen();
                                        },
                                      ),
                                    );
                              favoList.isEmpty
                                  ? showToast("No Favorities, Add Some..")
                                  : Container();

                              // print(FirestoreData.getFavList(widget.userID)
                              //     .then((value) {
                              //   print(value);
                              // }));
                            },
                            child: const Text(
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
                          height: height * 0.04,
                        ),
                        Container(
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextButton(
                            onPressed: () async {
                              GoogleSignIn googleSignIn = GoogleSignIn();
                              // bool _isSigned = await _googleSignIn.isSignedIn();

                              setState(() {
                                SharedPrefs.preferences.clear();
                              });

                              await googleSignIn.signOut();
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const HomeScreen();
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
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
