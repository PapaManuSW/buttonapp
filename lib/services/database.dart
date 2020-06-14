import 'package:button_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static const String gameData = 'gameData';
  static const String userData = 'userData';
  final Firestore _db = Firestore.instance;

  updateUser(User user) async {
    await _db.collection(user.uuid).document(userData).setData(user.userData.map);
    await _db.collection(user.uuid).document(gameData).setData(user.gameData.map);
  }

  updateTimestamp(User user, Timestamp timestamp) {
    _db.collection(user.uuid).document(gameData).updateData({'nextClickAt': timestamp});
  }

  updateStreak(User user, int streakValue) {
    _db.collection(user.uuid).document(gameData).updateData({'streak': streakValue});
  }

  incrementStreak(User user) {
    _db.collection(user.uuid).document(gameData).updateData(<String, dynamic>{'streak': FieldValue.increment(1)});
  }
}
