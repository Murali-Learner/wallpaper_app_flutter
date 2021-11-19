import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wallpaper_app/screens/homeScreen.dart';
import 'package:wallpaper_app/screens/wallpaperScreen.dart';

// ignore: must_be_immutable
class FavImages extends StatelessWidget {
  List favoList = [];
  FavImages({required this.favoList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Favorities"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Swiper(
          scrollDirection: Axis.vertical,
          itemCount: favoList.length,
          itemBuilder: (context, index) {
            print(favoList.length);
            return Container(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: favoList[index],
                placeholder: (context, url) {
                  return Center(child: CircularProgressIndicator());
                },
                errorWidget: (context, url, error) {
                  return Center(child: CircularProgressIndicator());
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
