// @dart=2.9

import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_app/screens/methds/firestoreData.dart';
import 'package:wallpaper_app/screens/methds/showtoast.dart';
import 'package:wallpaper_app/screens/methds/unsplashApi.dart';
import 'package:wallpaper_app/screens/sharedPrefs.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Wallpaper extends StatefulWidget {
  String category;
  Wallpaper({this.category});

  @override
  _WallpaperState createState() => _WallpaperState();
}

List favList = [];

class _WallpaperState extends State<Wallpaper> {
  List wallPaperList = [];
  String userId = "";
  initState() {
    apiResponse(widget.category).then((data) {
      if (data.length != 0) {
        data.forEach((element) {
          setState(() {
            wallPaperList.add({
              "url": element['urls']['full'],
              "is_fav": false,
            });
          });
        });
      }
    });
    SharedPrefs.getData().then((value) {
      print(value);
      setState(() {
        userId = value;
      });
    });
    super.initState();
  }

  bool _isVisible = false;
  bool _isInLIst = false;

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: wallPaperList.length != 0
                    ? Swiper(
                        itemCount: wallPaperList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: wallPaperList[index]['url'],
                                    placeholder: (context, url) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorWidget: (context, url, error) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              ),
                              _bottomWidget(
                                wallPaperList[index]['url'],
                                wallPaperList[index]["is_fav"],
                                index,
                                _height,
                                _width,
                                userId,
                              ),
                            ],
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  bool _loading = false;
  http.Response response;

  List wallpaperOpt = [
    {"HOME SCREEN": 1},
    {"LOCK SCREEN": 2},
    {"BOTH SCREENS": 3},
  ].toList();
  void _setWallPapaer(String url, wallpaperLoc) async {
    int location = WallpaperManager.HOME_SCREEN;
    setState(() {
      _loading = true;
    });
    var uriVal = Uri.parse(url);
    try {
      showToast("Downloading....");
      print("Downloading....");
      response = await http.get(
        uriVal,
      );
      var bytes = response.bodyBytes;
      print(bytes);
      String fileName = generateRandomString(5);
      if (Platform.isIOS) {
        var dir = await getApplicationDocumentsDirectory();
        var file = File("${dir.path}/myFile_$fileName.jpeg");
        print(file.path);
        await file.writeAsBytes(bytes).then((value) async {
          print("WallPaper Saved");
          showToast("WallPaper Saved");

          await WallpaperManager.setWallpaperFromFile(file.path, location)
              .then((_isSet) {
            if (_isSet) {
              showToast("WallPaper Set");
              print("WallPaper Set");
              setState(() {
                _loading = false;
              });
            }
          });
        });
        setState(() {
          _loading = false;
        });
      } else {
        var dir = await getExternalStorageDirectory();
        var file = File("${dir.path}/myFile_$fileName.jpeg");
        print(file.path);
        await file.writeAsBytes(bytes).then(
          (value) async {
            showToast("WallPaper Saved");
            print("WallPaper Saved");
            await WallpaperManager.setWallpaperFromFile(file.path, location)
                .then(
              (bool _isSet) {
                if (_isSet) {
                  showToast("WallPaper Set");
                  print("WallPaper Set");
                  setState(() {
                    _loading = false;
                  });
                }
              },
            );
          },
        );

        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print("Exception Networkservice.dart post():" + e.toString());
      showToast("Sevice down. Please try again later");

      setState(() {
        _loading = false;
      });
    }
  }

  Widget _bottomWidget(
      String url, bool _isFav, int index, _height, _width, userId) {
    return GestureDetector(
      onTap: () {
        _isVisible = !_isVisible;
        setState(() {});
      },
      child: Visibility(
        visible: _isVisible,
        child: Container(
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          padding: EdgeInsets.only(bottom: _height * 0.02, top: _height * 0.91),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  // Alert Dialog
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        title: Text(
                          "Set Wallpaper",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.acme(fontWeight: FontWeight.w500),
                        ),
                        contentPadding: EdgeInsets.only(right: 100),
                        actions: [
                          Column(
                            children: [
                              Container(
                                height: _height * 0.18,
                                width: _width * 0.8,
                                child: ListView.builder(
                                  itemCount: wallpaperOpt.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.black,
                                          width: _width * 1,
                                          height: _height * 0.001,
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            print(wallpaperOpt[index]
                                                .values
                                                .toString());
                                            _setWallPapaer(url,
                                                wallpaperOpt[index].values);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            wallpaperOpt[index].keys.toString(),
                                            style: GoogleFonts.robotoMono(
                                                // fontSize: 2,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  height: _height * 0.045,
                  width: _width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black38,
                  ),
                  child: Text(
                    "Set Wallpaper",
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              userId == null
                  ? Container()
                  : FutureBuilder<bool>(
                      future: FirestoreData.getFav(userId, url),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? IconButton(
                                onPressed: () async {
                                  setState(() {
                                    wallPaperList.elementAt(index)["is_fav"] =
                                        !wallPaperList
                                            .elementAt(index)["is_fav"];
                                  });
                                  await FirestoreData.addFavList(
                                      favList, userId, url);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color:
                                      snapshot.data ? Colors.red : Colors.white,
                                  size: 40,
                                ),
                              )
                            : Container(
                                alignment: Alignment.bottomCenter,
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
