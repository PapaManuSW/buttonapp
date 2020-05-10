import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uuid;
  final UserData userData;
  final GameData gameData;

  User(this.uuid, this.userData, this.gameData);
}

class UserData {
  final String email;
  final String name;
  final int
      notificationInterval; //every how many seconds to send a notification
  final String registrationToken; //for sending notifications
  UserData(
      this.email, this.name, this.notificationInterval, this.registrationToken);
}

class GameData {
  final int streak;
  final Timestamp nextClickAt;
  final int longestStreak;

  GameData(this.streak, this.nextClickAt, this.longestStreak);
}
