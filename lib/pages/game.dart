import 'dart:async';

import 'package:button_app/secondary.dart';
import 'package:button_app/utils/firebaseUtils.dart';
import 'package:button_app/utils/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String COLLECTION = 'labels_collection';

class GamePage extends StatefulWidget {
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _days = 25;
  double _progressPercentage = 0.7;
  DateTime _countDown = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _initScheduledTask();
    initFirestoreStreamFor(COLLECTION, _onDataChanged);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _onDataChanged(QuerySnapshot data) {
    _setCountDown(data);
    _setPercentage();
    _setDayCounter(data);
  }

  void _initScheduledTask() {
    // TODO just to see it moving set to 1 second
    _timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _setPercentage());
  }

  void _setDayCounter(QuerySnapshot data) {
    setState(() {
      _days = data.documents.elementAt(1).data['numberOfHit'];
    });
  }

  void _setCountDown(QuerySnapshot data) {
    setState(() {
      _countDown = data.documents.elementAt(1).data['timestamp'].toDate();
    });
  }

  void _setPercentage() {
    setState(() {
      _progressPercentage = computePercentage(_countDown);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget shareButton = IconButton(
      icon: Icon(Icons.share),
      color: Theme.of(context).iconTheme.color,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SecondPage()));
      },
    );

    Widget numberOfDays = Stack(
      children: <Widget>[
        Text(
          '$_days',
          style: Theme.of(context).textTheme.display4,
        ),
        Positioned(
          right: 0,
          bottom: 5,
          child: Text(
            'Days', // TODO: exception for 1 day
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      ],
    );

    Widget countDownFinal = Stack(
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 10.0,
            backgroundColor: Colors.transparent,
            value: _progressPercentage,
          ),
          height: 150.0,
          width: 150.0,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              DateFormat('kk:mm:ss').format(_countDown),
              style: Theme.of(context).textTheme.display1,
            ),
          ),
        ),
      ],
    );

    Widget mainButton = RaisedButton(
        color: Theme.of(context).primaryColor,
//        textColor: Theme.of(context).textTheme.button.color,
        splashColor: Colors.cyanAccent,
        child: Text(
          'Button',
          style: Theme.of(context).textTheme.button,
        ),
        onLongPress: () {
          updateTimeStamp(
              COLLECTION,
              'test_label2',
              Timestamp.fromDate(
                  DateTime.now().add(new Duration(seconds: 50))));
        },
        onPressed: () {
          verifyPressOnTime(_countDown);
        });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[shareButton],
        ),
        numberOfDays,
        SizedBox(height: 20),
        countDownFinal,
        SizedBox(height: 50),
        mainButton,
      ],
    );
  }
}
