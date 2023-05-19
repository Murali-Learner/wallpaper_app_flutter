import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference userCollection =
      _firestore.collection("userDetails");

  static const emailKey = "email";
  static const uidKey = "userId";
  static const namekey = "displayName";
  static const photokey = "photoUrl";

  static Future<DocumentSnapshot> getUserData(userID) async {
    var response = await userCollection.doc(userID).get();
    log(response.toString());
    return response;
  }

  static Future addUserData(
    email,
    userId,
    displayName,
    photoUrl,
  ) async {
    userCollection.doc(userId).set(({
          emailKey: email,
          namekey: displayName,
          "favouritiesList": [],
          uidKey: userId,
          photokey: photoUrl,
        }));
  }

  static Future<bool> isTokenExists(String userID) async {
    var response = await userCollection.doc(userID).get();
    return response.exists;
  }

  static Future<bool> getFav(String docId, String url) async {
    var imageCol = await userCollection.doc(docId).get();
    List imageList = imageCol["favouritiesList"];
    return imageList.contains(url);
  }

  static Future<List> getFavList(String docId) async {
    var imageCol = await userCollection.doc(docId).get();
    List imageList = imageCol["favouritiesList"];
    return imageList;
  }

  static Future addFavList(List favList, String docId, String url) async {
    var collection = userCollection.doc(docId);
    var docSnap = await collection.get();
    List listUrls = docSnap.get("favouritiesList");
    if (listUrls.contains(url)) {
      collection.update({
        "favouritiesList": FieldValue.arrayRemove([url])
      });
    } else {
      collection.update({
        "favouritiesList": FieldValue.arrayUnion([url])
      });
    }
    getFav(docId, url).then((value) => print(value));
    // return imageList["favouritiesList"];
  }
}
