import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wallpaper_app/screens/wallpaperScreen.dart';

class FavImages extends StatefulWidget {
  @override
  _FavImagesState createState() => _FavImagesState();
}

class _FavImagesState extends State<FavImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Swiper(
          scrollDirection: Axis.vertical,
          itemCount: favList.length,
          itemBuilder: (context, index) {
            if (favList.length != 0) {
              return Container(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: favList[index],
                  placeholder: (context, url) {
                    return CircularProgressIndicator();
                  },
                  errorWidget: (context, url, error) {
                    return CircularProgressIndicator();
                  },
                ),
              );
            } else {
              return Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Wallpaper();
                      },
                    ));
                  },
                  child: Text("Please Add Favorites"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
