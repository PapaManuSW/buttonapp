import 'package:button_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Future updateUser(User user) async {
    await _db.collection(user.uuid).document('userData').setData(user.userData.map);
    await _db.collection(user.uuid).document('gameData').setData(user.gameData.map);
  }

}