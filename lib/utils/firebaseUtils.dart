import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

initFirestoreStreamForUser(
    String collection, Function onDataChanged, String userId) {
  Firestore.instance.collection(collection).snapshots().listen((data) {
    data.documents.forEach((element) {
      if (element.documentID.compareTo(userId) == 0) {
        onDataChanged(element);
        return;
      }
    });
  });
}

updateTimeStamp(String collection, String document, Timestamp timestamp) {
  Firestore.instance
      .collection(collection)
      .document(document)
      .updateData({'nextClickAt': timestamp});
}

incrementHitCounter(String collection, String document) {
  Firestore.instance
      .collection(collection)
      .document(document)
      .updateData(<String, dynamic>{'numberOfHit': FieldValue.increment(1)});
}

resetHitCounter(String collection, String document) {
  Firestore.instance
      .collection(collection)
      .document(document)
      .updateData({'numberOfHit': 0});
}

// TODO not used
StreamBuilder<QuerySnapshot> fetchFromFireStore() {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('users').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return new Text('Loading...');
        default:
          return new Text("...");
      }
    },
  );
}
