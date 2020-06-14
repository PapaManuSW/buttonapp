import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  static FirebaseNotifications _instance;
  String _token;

  FirebaseNotifications._createInstance();

  factory FirebaseNotifications() {
    if (_instance == null) {
      _instance = FirebaseNotifications._createInstance();
      _instance._setUpFirebase();
    }
    return _instance;
  }

  String get token => _token;

  Future<void> _setUpFirebase() async {
    _firebaseMessaging = FirebaseMessaging();
    _token = await _firebaseMessaging.getToken();
    firebaseCloudMessaging_Listeners();
  }

  void onTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.forEach((newToken) {
      print("Token refreshed: $newToken");
      // TODO implement below
      sendTokenToServer(newToken);
    });
  }

  void onTokenRefresh2() {
    _firebaseMessaging.onTokenRefresh.single.then((newToken) {
      print("Token refreshed2: $newToken");
      // TODO implement below
      sendTokenToServer(newToken);
    });
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iosPermissions();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iosPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void sendTokenToServer(String newToken) {}
}
