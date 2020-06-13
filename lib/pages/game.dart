import 'dart:async';

import 'package:button_app/models/user.dart';
import 'package:button_app/secondary.dart';
import 'package:button_app/services/auth.dart';
import 'package:button_app/utils/firebaseUtils.dart';
import 'package:button_app/utils/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const NEXT_CLICK_AT = 'nextClickAt';
const STREAK = 'streak';

class GamePage extends StatefulWidget {
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // TODO fix initial values
  int _days = 25;
  double _progressPercentage = 0.7;
  DateTime _countDown = DateTime.now();
  Timer _timer;
  int id = 0;

  @override
  void initState() {
    super.initState();
    _initScheduledTask();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _onDataChanged(DocumentSnapshot data) {
    _setCountDown(data);
    _setPercentage();
    _setDayCounter(data);
  }

  void _initScheduledTask() {
    // TODO just to see it moving set to 1 second
    _timer =
        Timer.periodic(Duration(minutes: 5), (Timer t) => _setPercentage());
  }

  void _setDayCounter(DocumentSnapshot data) {
    setState(() {
      _days = data[NUMBER_OF_HITS];
    });
  }

  void _setCountDown(DocumentSnapshot data) {
    var countdown = data[NEXT_CLICK_AT].toDate();
    setState(() {
      _countDown = countdown;
    });
  }

  Future<void> _setPercentage() async {
    var percentage = await computePercentage(_countDown);
    setState(() {
      _progressPercentage = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<User>(context);
    // TODO can model be null at this point? e.g. the provider did not received values yet?
    initFirestoreStreamForUser(model.uuid, _onDataChanged);
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
          style: Theme.of(context).textTheme.headline1,
        ),
        Positioned(
          right: 0,
          bottom: 5,
          child: Text(
            'Days', // TODO: exception for 1 day
            style: Theme.of(context).textTheme.bodyText1,
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
              style: Theme.of(context).textTheme.headline4,
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
          //TODO Just for testing
          getCurrentTime().then((now) {
            updateTimeStamp(
                COLLECTION, USER, Timestamp.fromDate(nextTimeToPress(now)));
          });
        },
        onPressed: () {
          verifyPressOnTime(_countDown).then((pressedOnTime) {
            if (pressedOnTime) {
              incrementHitCounter(COLLECTION, USER);
              getCurrentTime().then((now) {
                updateTimeStamp(
                    COLLECTION, USER, Timestamp.fromDate(nextTimeToPress(now)));
              });
              scheduleNotificationForUser(userId);
            } else {
              resetHitCounter(COLLECTION, USER);
            }
          });
//          scheduleNotification(
//              id++, _countDown.subtract(new Duration(hours: 1)));
//          scheduleNotification(
//              id++, _countDown.subtract(new Duration(minutes: 15)));
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
