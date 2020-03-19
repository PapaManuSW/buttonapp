import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Second Page'),
        ),
        body: fetchFromFireStore());
  }

  StreamBuilder<QuerySnapshot> fetchFromFireStore() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('label_collection').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document.documentID),
                  subtitle: new Text(document['numberOfHit'].toString()),
                  onTap: () => _increaseNumberOfHit(document),
                );
              }).toList(),
            );
        }
      },
    );
  }

  _increaseNumberOfHit(DocumentSnapshot document) async {
    await Firestore.instance
        .collection('label_collection')
        .document(document.documentID)
        .updateData(<String, dynamic>{'numberOfHit': FieldValue.increment(1)});
  }
}
