import 'package:button_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String email;
  final Firestore _db = Firestore.instance;

  DatabaseService(this.email);

  Future updateUserData(UserData userData) async {
    return await _db.collection(email).document('user_data').setData({
      'name': userData.name,
      'uid': userData.uid,
      'email': userData.email
    });
  }

}