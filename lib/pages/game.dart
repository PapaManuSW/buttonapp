import 'dart:async';

import 'package:button_app/models/user.dart';
import 'package:button_app/secondary.dart';
import 'package:button_app/services/database.dart';
import 'package:button_app/utils/firebaseUtils.dart';
import 'package:button_app/utils/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const NEXT_CLICK_AT = 'nextClickAt';
const STREAK = 'streak';

class GamePage extends StatefulWidget {
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final DatabaseService _db = DatabaseService();

  // TODO fix initial values
  int _days;
  double _countDownPercentage;
  String _countDownText = '';
  Timer _timer;
  DocumentSnapshot _data;
  int _differenceInSeconds;

  @override
  void initState() {
    super.initState();
    _initCountDown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _onDataChanged(DocumentSnapshot data) {
    _data = data;
    _setDayCounter(data);
    _updateUI();
  }

  void _initCountDown() {
    _timer = Timer.periodic(Duration(seconds: 1), ((Timer t) {
      _updateUI();
    }));
  }

  Future _updateUI() async {
    var countdown = _data[NEXT_CLICK_AT].toDate();
    _differenceInSeconds = await computeRemainingTimeInSeconds(countdown);
    _updateCircularCountDown(_differenceInSeconds);
    _setCountDownText(_differenceInSeconds);
  }

  void _setCountDownText(int differenceInSeconds) {
    var remainingTime = Duration(seconds: differenceInSeconds);
    final List<String> parts = remainingTime.toString().split(":");
    final String hour = parts[0].padLeft(2, '0');
    final String minutes = parts[1].padLeft(2, '0');
    final String seconds = parts[2].split(".")[0].padLeft(2, '0');
    setState(() {
      _countDownText = '$hour:$minutes:$seconds';
    });
  }

  void _setDayCounter(DocumentSnapshot data) {
    setState(() {
      _days = data['streak'];
    });
  }

  Future<void> _updateCircularCountDown(int differenceInMinutes) async {
    const secondsInOneDay = 60 * 60 * 24;
    var percentage = differenceInMinutes / secondsInOneDay;
    setState(() {
      _countDownPercentage = percentage;
    });
  }

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<User>(context);
    // TODO can model be null at this point? e.g. the provider did not received values yet?
    initFirestoreGameDataStreamForUser(_user.uuid, _onDataChanged);
    Widget shareButton = IconButton(
      icon: Icon(Icons.share),
      color: Theme.of(context).iconTheme.color,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
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
            _days == 0 ? 'Day' : 'Days',
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
            value: _countDownPercentage,
          ),
          height: 150.0,
          width: 150.0,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              _countDownText,
              //DateFormat('kk:mm:ss').format(_countDown),
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
            _db.updateTimestamp(_user, Timestamp.fromDate(nextTimeToPress(now)));
            scheduleNotificationForUser(_user.uuid);
          });
        },
        onPressed: () {
          verifyPressOnTime(_differenceInSeconds).then((pressedOnTime) {
            if (pressedOnTime) {
              _db.incrementStreak(_user);
              getCurrentTime().then((now) {
                _db.updateTimestamp(_user, Timestamp.fromDate(nextTimeToPress(now)));
              });
              scheduleNotificationForUser(_user.uuid);
              // todo delete all schedule notifications?
            } else {
              _db.updateStreak(_user, 0);
            }
          });
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
