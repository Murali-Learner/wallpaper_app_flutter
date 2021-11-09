// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wallpaper_app/screens/favimages.dart';
import 'package:wallpaper_app/screens/methds/firestoreData.dart';
import 'package:wallpaper_app/screens/methds/unsplashApi.dart';
import 'package:wallpaper_app/screens/sharedPrefs.dart';

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
    return Scaffold(
      body: Container(
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
                            _setWallPaper(
                              wallPaperList[index]['url'],
                              wallPaperList[index]["is_fav"],
                              index,
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
    );
  }

  Widget _setWallPaper(String url, bool _isFav, int index) {
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
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                clipBehavior: Clip.antiAlias,
                onPressed: () {
                  if (_isFav) {
                    favList.add(url);
                  }
                  print(favList.length);
                  // favList.clear();

                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return FavImages();
                    },
                  ));
                  // print(url);
                },
                child: Text("SetWallpaper"),
              ),
              FutureBuilder<bool>(
                  future: FirestoreData.getFav(userId, url),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? IconButton(
                            onPressed: () async {
                              setState(() {
                                wallPaperList.elementAt(index)["is_fav"] =
                                    !wallPaperList.elementAt(index)["is_fav"];
                              });
                              // if (wallPaperList.elementAt(index)["is_fav"]) {
                              await FirestoreData.addFavList(
                                  favList, userId, url);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: snapshot.data ? Colors.red : Colors.white,
                              size: 40,
                            ))
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
