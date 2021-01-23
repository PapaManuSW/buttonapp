import 'package:button_app/models/UIData.dart';
import 'package:button_app/models/user.dart';
import 'package:button_app/secondary.dart';
import 'package:button_app/services/database.dart';
import 'package:button_app/utils/firebaseUtils.dart';
import 'package:button_app/utils/misc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'GameBloc.dart';

class GamePage extends StatefulWidget {
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final DatabaseService _db = DatabaseService();
  GameBloc gameBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //gameBloc.stopCountDown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<User>(context);
    gameBloc = GameBloc(_user.uuid);
    //gameBloc.startCountDown();
    Widget shareButton = IconButton(
      icon: Icon(Icons.share),
      color: Theme.of(context).iconTheme.color,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage()));
      },
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

    return StreamBuilder<UIData>(
        stream: gameBloc.uiDataStream,
        builder: (BuildContext context, AsyncSnapshot<UIData> uiData) {
          if (uiData.hasData) {
            return Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[shareButton],
              ),
              _buildStreakWidget(context, uiData.data.streak),
              SizedBox(height: 20),
              _buildCountDown(uiData.data.percentageRemainingTime, uiData.data.remainingTimeText),
              SizedBox(height: 50),
              mainButton
            ]);
          } else {
            return _buildLoadingWidget();
          }
        });
  }

  Widget _buildStreakWidget(BuildContext context, int streak) {
    return Stack(
      children: <Widget>[
        Text(
          '$streak',
          style: Theme.of(context).textTheme.headline1,
        ),
        Positioned(
          right: 0,
          bottom: 5,
          child: Text(
            streak == 0 ? 'Day' : 'Days',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }

  Widget _buildCountDown(percentageRemainingTime, countDownText) {
    return Stack(
      children: <Widget>[
        SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 10.0,
            backgroundColor: Colors.transparent,
            value: percentageRemainingTime,
          ),
          height: 150.0,
          width: 150.0,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              countDownText,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildLoadingWidget() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
      SpinKitChasingDots(
        color: Theme.of(context).iconTheme.color,
        size: 50.0,
      ),
      Text(
        "Just trying to find out what you did last time, hold on :)",
        style: TextStyle(fontSize: 20, color: Colors.white),
      )
    ]);
  }
}
