// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wallpaper_app/screens/methds/unsplashApi.dart';

class Wallpaper extends StatefulWidget {
  String category;
  Wallpaper({this.category});

  @override
  _WallpaperState createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  bool _isVisible = false;
  // void showWidget() {
  //   setState(() {
  //     _isVisible = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            FutureBuilder(
              future: apiResponse(widget.category),
              builder: (context, snapshot) {
                // print(snapshot.data);
                if (snapshot.hasData) {
                  // print(widget.category);
                  return Expanded(
                    child: Swiper(
                      itemCount: snapshot.data.toString().length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  print(_isVisible);
                                  _isVisible = !_isVisible;
                                });
                              },
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot.data[index]['urls']
                                      ['full'],
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
                            _setWallPaper(),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _setWallPaper() {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: _isVisible,
      child: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.black12,
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () {}, child: Text("SetWallpaper")),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }
}
