import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:button_app/secondary.dart';

class GamePage extends StatefulWidget {
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _days = 25;
  double _progressPercentage = 0.7;
  String _countDown = DateFormat('kk:mm:ss')
      .format(DateTime.now()); // DateTime.now just for a time example

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
              '$_countDown',
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
        onPressed: () {
          // TODO: some functionality
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
