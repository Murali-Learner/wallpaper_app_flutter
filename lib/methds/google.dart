import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleClass {
  static GoogleSignIn _googleSignIn = GoogleSignIn();
  static FirebaseAuth auth = FirebaseAuth.instance;
  static var photoId = _googleSignIn.currentUser.photoUrl;
  static var uid = _googleSignIn.currentUser.id;
  static Future signInGoogle() async {
    bool _isSigned = await _googleSignIn.isSignedIn();
    if (_isSigned) {
      await _googleSignIn.signOut();
      print("Logout");
    }
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCreds =
        await auth.signInWithCredential(credential);
    User? user = userCreds.user;
    var photoId = user!.displayName;
    print(user.displayName);
    Map userInfo = {
      "name": user.displayName,
      "email": user.email,
      "uid": user.uid,
      "photoUrl": user.photoURL,
    };

    return userCreds != null ? userInfo : {};
  }
}
