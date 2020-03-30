import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Second Page'),
        ),
        body: FireStoreWidget());
  }
}

class FireStoreWidget extends StatefulWidget {
  @override
  _FireStoreWidgetState createState() => _FireStoreWidgetState();
}

class _FireStoreWidgetState extends State<FireStoreWidget> {
  ListView _listView;

  void _handleOnChanged(ListView listView) {
    setState(() {
      _listView = listView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FireBaseListView(
        listView: _listView,
        onChanged: _handleOnChanged,
      ),
    );
  }
}

class FireBaseListView extends StatelessWidget {
  final ListView listView;

  final ValueChanged<ListView> onChanged;

  FireBaseListView({Key key, @required this.listView, @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fetchFromFireStore();
  }

  StreamBuilder<QuerySnapshot> fetchFromFireStore() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('labels_collection').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return _buildListView(snapshot);
        }
      },
    );
  }

  ListView _buildListView(AsyncSnapshot<QuerySnapshot> snapshot) {
    return new ListView(
      children: snapshot.data.documents.map((DocumentSnapshot document) {
        return new ListTile(
          title: new Text(document.documentID),
          subtitle: new Text(_setText(document)),
          onTap: () => _onTap(document),
          onLongPress: () => _onLongPress(document),
        );
      }).toList(),
    );
  }

  String _setText(DocumentSnapshot document) {
    var lastTap;
    var nextTap;
    if (document['timestamp'] != null) {
      lastTap = document['timestamp'].toDate();
      nextTap = lastTap.add(new Duration(days: 1)).toIso8601String();
    }
    return document['numberOfHit'].toString() +
        "\nLast clicked: " +
        lastTap.toString() +
        "\nTap me again at: " +
        nextTap.toString();
  }

  _onTap(DocumentSnapshot document) async {
    await _incrementCounter(document);
    DateTime now = Timestamp.now().toDate();
    final DateTime lastTimestampOnServer = document['timestamp'].toDate();
    final int slack = 5; //seconds
    final DateTime whenShouldTapNextTime =
        lastTimestampOnServer.add(new Duration(seconds: 10));
    var differenceInSeconds = whenShouldTapNextTime.difference(now).inSeconds;
    if (differenceInSeconds > slack) {
      print("Too early: " + differenceInSeconds.toString());
    } else if (differenceInSeconds < -slack) {
      print("Too late: " + differenceInSeconds.toString());
    } else {
      await _updateTimeStamp(document);
      print("On time!!!");
    }
//    onChanged(listView);
  }

  _onLongPress(DocumentSnapshot document) async {
    await _updateTimeStamp(document);
  }

  Future _incrementCounter(DocumentSnapshot document) async {
    await Firestore.instance
        .collection('labels_collection')
        .document(document.documentID)
        .updateData(<String, dynamic>{'numberOfHit': FieldValue.increment(1)});
  }

  Future _updateTimeStamp(DocumentSnapshot document) async {
    await Firestore.instance
        .collection('labels_collection')
        .document(document.documentID)
        .updateData(<String, dynamic>{'timestamp': Timestamp.now()});
  }
}
