import 'dart:convert';

import 'package:button_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

initFirestoreGameDataStreamForUser(String userId, Function onDataChanged) {
  Firestore.instance
      .collection(userId)
      .document(DatabaseService.gameData)
      .snapshots()
      .listen((data) {
    onDataChanged(data);
    return;
  });
}

//updateTimeStamp(String collection, String document, Timestamp timestamp) {
//  Firestore.instance.collection(collection).document(document).updateData({'nextClickAt': timestamp});
//}

//incrementHitCounter(String collection, String document) {
//  Firestore.instance.collection(collection).document(document).updateData(<String, dynamic>{'numberOfHit': FieldValue.increment(1)});
//}
//
//resetHitCounter(String collection, String document) {
//  Firestore.instance.collection(collection).document(document).updateData({'numberOfHit': 0});
//}

Future<http.Response> scheduleNotificationForUser(String userId) {
  print("Scheduling notification");
  return http.post(
    'https://europe-west1-api-5485359515497309438-439551.cloudfunctions.net/scheduleTaskToSendNotification',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userId': userId,
    }),
  );
}
