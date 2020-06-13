import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uuid;
  final UserData userData;
  final GameData gameData;

  User(this.uuid, this.userData, this.gameData);
}

class UserData {
  final String email;
  final int notificationInterval;
  final String registrationToken;

  UserData(this.email, this.notificationInterval, this.registrationToken);

  get map {
    return {
      'email': email,
      'notificationInterval': notificationInterval,
      'registrationToken': registrationToken
    };
  }
}

class GameData {
  final int streak;
  final Timestamp nextClickAt;
  final int longestStreak;

  GameData(this.streak, this.longestStreak, this.nextClickAt);

  get map {
    return {
      'streak': streak,
      'longestStreak': longestStreak,
      'nextClickAt': nextClickAt.toString()
    };
  }
}
