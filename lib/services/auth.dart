import 'package:button_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
   final FirebaseAuth _authInstance = FirebaseAuth.instance;

    User _getUserFromFireStore(FirebaseUser user) {
      return (user == null) ? null : User(uid: user.uid);
    }

    Stream<User> get user {
      print('In stream get user');
      return _authInstance.onAuthStateChanged.map(_getUserFromFireStore);
    }

   Future signInEmail(String email, String password) async {
      try {
         AuthResult result = await _authInstance.signInWithEmailAndPassword(email: email, password: password);
         FirebaseUser firebaseUser = result.user;
         return _getUserFromFireStore(firebaseUser);
      } catch (e) {
        print(e.toString());
        return null;
      }
   }

   Future signOut() async {
     try {
       return await _authInstance.signOut();
      } catch (e) {
       print(e.toString());
       return null;
     }
   }

}
