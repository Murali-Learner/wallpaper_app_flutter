import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

// ignore: must_be_immutable
class FavImages extends StatelessWidget {
  List favList = [];
  FavImages({super.key, required this.favList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favorities"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Swiper(
          scrollDirection: Axis.vertical,
          itemCount: favList.length,
          itemBuilder: (context, index) {
            debugPrint(favList.length.toString());
            return CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: favList[index],
              placeholder: (context, url) {
                return const Center(child: CircularProgressIndicator());
              },
              errorWidget: (context, url, error) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }
}
