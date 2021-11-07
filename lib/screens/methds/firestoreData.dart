import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static CollectionReference userCollection =
      _firestore.collection("userDetails");

  static final emailKey = "email";
  static final uidKey = "userId";
  static final namekey = "displayName";
  static final photokey = "photoUrl";

  static Future<QuerySnapshot> readUser() async {
    QuerySnapshot userList = await userCollection.get();

    return userList;
  }

  static Future<DocumentSnapshot> getUserData(userID) async {
    var response = await userCollection.doc(userID).get();
    print(response);
    return response;
  }

  static Future addUserData(email, userId, displayName, photoUrl) async {
    userCollection.doc(userId).set(({
          emailKey: email,
          namekey: displayName,
          uidKey: userId,
          "favouritiesList": [],
          photokey: photoUrl,
        }));
  }

  static Future<bool> isTokenExists(String userID) async {
    var response = await userCollection.doc(userID).get();
    return response.exists;
  }
}
