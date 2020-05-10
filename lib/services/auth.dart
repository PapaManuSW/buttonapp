import 'package:button_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final GoogleSignIn _googleInstance = GoogleSignIn(signInOption: SignInOption.games, scopes: ['email']);

  Future signInWithGoogle() async {

    if (await _googleInstance.isSignedIn()) {
      await _googleInstance.signOut();
      print('already signed in');
    }

    final GoogleSignInAccount googleSignInAccount = await _googleInstance.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult _authResult = await _authInstance.signInWithCredential(credential);
    final FirebaseUser _authUser = _authResult.user;
    return _getUserFromFireStore(_authUser);
  }

  User _getUserFromFireStore(FirebaseUser _user) {
    if (_user == null) {
      return null;
    }
    User user = User(email: _user.email);
    UserData userData = UserData(_user.email, _user.displayName, _user.uid);
    GameData gameData = GameData();
    gameData.streak = 10;
    user.userData = userData;
    user.gameData = gameData;
    return user;
  }

  Stream<User> get user {
    print('In stream get user');
    return _authInstance.onAuthStateChanged.map(_getUserFromFireStore);
  }

  Future signInEmail(String email, String password) async {
    try {
      AuthResult result = await _authInstance.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      User user = _getUserFromFireStore(firebaseUser);

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      await _googleInstance.signOut();
      return await _authInstance.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
