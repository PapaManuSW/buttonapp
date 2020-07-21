import 'package:button_app/models/user.dart';
import 'package:button_app/secondary.dart';
import 'package:button_app/services/database.dart';
import 'package:button_app/utils/firebaseUtils.dart';
import 'package:button_app/utils/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'GameBloc.dart';

const NEXT_CLICK_AT = 'nextClickAt';
const STREAK = 'streak';

class GamePage extends StatefulWidget {
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final DatabaseService _db = DatabaseService();
  final GameBloc gameBloc = GameBloc();
  double _percentageRemainingTime;
  String _countDownText = '';
  int _streak = 0;

  @override
  void initState() {
    super.initState();
  }

  void onTickText(text) {
    setState(() {
      _countDownText = text;
    });
  }

  void onTickProgressCircle(percentage) {
    setState(() {
      _percentageRemainingTime = percentage;
    });
  }

  @override
  void dispose() {
    gameBloc.stopCountDown();
    super.dispose();
  }

  _onStreakChanged(streak) {
    setState(() {
      _streak = streak;
    });
  }

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<User>(context);
    // TODO can model be null at this point? e.g. the provider did not received values yet?
    gameBloc.initFireStoreStream(_user.uuid, _onStreakChanged, onTickText, onTickProgressCircle);
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
          '$_streak',
          style: Theme.of(context).textTheme.headline1,
        ),
        Positioned(
          right: 0,
          bottom: 5,
          child: Text(
            _streak == 0 ? 'Day' : 'Days',
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
            value: _percentageRemainingTime,
          ),
          height: 150.0,
          width: 150.0,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              _countDownText,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ],
    );

    Widget mainButton = RaisedButton(
        color: Theme.of(context).primaryColor,
        splashColor: Colors.cyanAccent,
        child: Text(
          'Press me',
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
          verifyPressOnTime(gameBloc.differenceInSeconds).then((pressedOnTime) {
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
          _countDownText == null ? Text("Loading") : countDownFinal,
          SizedBox(height: 50),
          mainButton,
        ]);
  }
}
