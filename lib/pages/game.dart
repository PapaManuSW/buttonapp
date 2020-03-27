import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:button_app/secondary.dart';

class GamePage extends StatefulWidget {
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _days = 25;
  String _countDown = DateFormat('kk:mm:ss')
      .format(DateTime.now()); // DateTime.now just for a time example

  @override
  Widget build(BuildContext context) {
    Widget shareButton = new IconButton(
      icon: Icon(Icons.share),
      color: Theme.of(context).iconTheme.color,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SecondPage()));
      },
    );

    Widget numberOfDays = new Stack(
      children: <Widget>[
        Text(
          '$_days',
          style: Theme.of(context).textTheme.display4,
        ),
        Positioned(
          right: 0,
          bottom: 10,
          child: Text(
            'Days', // TODO: exception for 1 day
            style: Theme.of(context).textTheme.body2,
          ),
        ),
      ],
    );

    Widget countDown = new Text(
      '$_countDown',
      style: Theme.of(context).textTheme.display2,
    );

    Widget mainButton = new RaisedButton(
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
        countDown,
        SizedBox(height: 30),
        mainButton,
      ],
    );
  }
}
