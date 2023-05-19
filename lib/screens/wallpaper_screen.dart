import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:my_wallpaper_app/methods/firestore_data.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:my_wallpaper_app/methods/show_toast.dart';
import 'package:my_wallpaper_app/methods/unsplash_api.dart';

import 'shared_prefs.dart';

// ignore: must_be_immutable
class Wallpaper extends StatefulWidget {
  final String category;
  Wallpaper({Key? key, required this.category}) : super(key: key);

  @override
  WallpaperState createState() => WallpaperState();
}

List favList = [];

class WallpaperState extends State<Wallpaper> {
  List wallPaperList = [];
  String userId = "";
  initState() {
    apiResponse(widget.category).then((data) {
      if (data.isNotEmpty) {
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Column(
          children: [
            Expanded(
              child: wallPaperList.isNotEmpty
                  ? Swiper(
                      itemCount: wallPaperList.length,
                      itemBuilder: (context, index) {
                        print(wallPaperList[index]['url']);
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
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorWidget: (context, url, error) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                            ),
                            _bottomWidget(
                              wallPaperList[index]['url'],
                              wallPaperList[index]["is_fav"],
                              index,
                              height,
                              width,
                              userId,
                            ),
                          ],
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  bool _loading = false;
  http.Response? response;

  List wallpaperOpt = [
    {"key": "HOME SCREEN", "value": 1},
    {"key": "LOCK SCREEN", "value": 2},
    {"key": "BOTH SCREEN", "value": 3},
  ];
  void _setWallPapaer(String url, wallpaperLoc) async {
    // int location = wallpaperLoc;
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
      var bytes = response!.bodyBytes;
      debugPrint(bytes.toString());
      String fileName = generateRandomString(5);
      if (Platform.isIOS) {
        var dir = await path_provider.getApplicationDocumentsDirectory();
        var file = File("${dir.path}/myFile_$fileName.jpeg");
        debugPrint(file.path);
        await file.writeAsBytes(bytes).then((value) async {
          debugPrint("WallPaper Saved");
          showToast("WallPaper Saved");

          await WallpaperManager.setWallpaperFromFile(file.path, wallpaperLoc)
              .then((isSet) {
            if (isSet) {
              showToast("WallPaper Set");
              debugPrint("WallPaper Set");
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
        var dir = await path_provider.getExternalStorageDirectory();
        var file = File("${dir!.path}/myFile_$fileName.jpeg");
        print(file.path);
        await file.writeAsBytes(bytes).then(
          (value) async {
            showToast("WallPaper Saved");
            print("WallPaper Saved");
            await WallpaperManager.setWallpaperFromFile(file.path, wallpaperLoc)
                .then(
              (bool isSet) {
                if (isSet) {
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
      String url, bool isFav, int index, height, width, userId) {
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
          padding: EdgeInsets.only(bottom: height * 0.02, top: height * 0.91),
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
                        contentPadding: const EdgeInsets.only(right: 100),
                        actions: [
                          Column(
                            children: [
                              Container(
                                height: height * 0.18,
                                width: width * 0.8,
                                child: ListView.builder(
                                  itemCount: wallpaperOpt.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.black,
                                          width: width * 1,
                                          height: height * 0.001,
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            print(wallpaperOpt[index]["value"]);
                                            _setWallPapaer(url,
                                                wallpaperOpt[index]["value"]);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            wallpaperOpt[index]["key"]
                                                .toString(),
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
                  height: height * 0.045,
                  width: width * 0.5,
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
                                  color: snapshot.data!
                                      ? Colors.red
                                      : Colors.white,
                                  size: 40,
                                ),
                              )
                            : Container(
                                alignment: Alignment.bottomCenter,
                                child: const CircularProgressIndicator(
                                  color: Colors.red,
                                ),
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
