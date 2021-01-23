import 'package:button_app/models/user.dart';
import 'package:button_app/services/database.dart';
import 'package:button_app/utils/firebaseNotifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final GoogleSignIn _googleInstance = GoogleSignIn(signInOption: SignInOption.games, scopes: ['email']);
  final DatabaseService _db = DatabaseService();
  final FirebaseNotifications firebaseNotifications = FirebaseNotifications();

  Future signInWithGoogle() async {
    print("NOW IS");
    if (await _googleInstance.isSignedIn()) {
      print('Already signed in');
    }
    final GoogleSignInAccount googleSignInAccount = await _googleInstance.signIn();
    print(googleSignInAccount.toString());

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult _authResult = await _authInstance.signInWithCredential(credential);
    final FirebaseUser _authUser = _authResult.user;
    User _user = _getUserFromFireStore(_authUser);
    await _db.updateUser(_user);
  }

  User _getUserFromFireStore(FirebaseUser _user) {
    if (_user == null) {
      return null;
    }
    UserData userData = UserData(_user.email, 86400, firebaseNotifications.token); //86400 = 23h30m
    GameData gameData = GameData(0, 0, Timestamp.now()); // TODO get this from ntp
    User user = User(_user.uid, userData, gameData);
    return user;
  }

  Stream<User> get user {
    return _authInstance.onAuthStateChanged.map(_getUserFromFireStore);
  }

  //Future signInEmail(String email, String password) async {
  //  try {
  //    AuthResult result = await _authInstance.signInWithEmailAndPassword(email: email, password: password);
  //    FirebaseUser firebaseUser = result.user;
  //    User user = _getUserFromFireStore(firebaseUser);
//
  //    return user;
  //  } catch (e) {
  //    print(e.toString());
  //    return null;
  //  }
  //}

  Future signOut() async {
    try {
//      await _googleInstance.signOut();
      return await _authInstance.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
