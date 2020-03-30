import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

initFirestoreStreamFor(String collection, Function onDataChanged) {
  Firestore.instance.collection(collection).snapshots().listen((data) {
    onDataChanged(data);
  });
}

updateTimeStamp(String collection, String document, Timestamp timestamp) {
  Firestore.instance
      .collection(collection)
      .document(document)
      .updateData({'timestamp': timestamp});
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
    stream: Firestore.instance.collection('labels_collection').snapshots(),
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
