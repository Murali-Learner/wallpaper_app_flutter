// @dart=2.9

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wallpaper_app/screens/methds/unsplashApi.dart';

class Wallpaper extends StatelessWidget {
  String category;
  Wallpaper({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          FutureBuilder(
            future: apiResponse(category),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                print(category);
                return Expanded(
                  child: Swiper(
                    itemCount: snapshot.data.toString().length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: snapshot.data[index]['urls']['full'],
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
      )),
    );
  }

  Widget _setWallPaper() {
    return Container(
      child: Row(
        children: [
          ElevatedButton(onPressed: () {}, child: Text("SetWallpaper")),
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
        ],
      ),
    );
  }
}
