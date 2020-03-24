import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:button_app/pages/game.dart';
import 'package:button_app/pages/leaderboards.dart';
import 'package:button_app/pages/shop.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button App',
      theme: ThemeData(
        primaryColor: Color(0xFF01A39D),
        accentColor: Colors.grey[700],
        textTheme: TextTheme(
            title: TextStyle(color: Colors.white),
            body2: TextStyle(color: Colors.grey[700]),
            display1: TextStyle(
                color: Colors.grey[700],
                fontSize: 29.0,
                fontWeight: FontWeight.w400),
            display4: TextStyle(
                color: Color(0xFF01A39D),
                fontWeight: FontWeight.w400,
                fontSize: 90.0),
            caption: TextStyle(color: Colors.grey[700]),
            button: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.grey[700]),
      ),
      home: MyHomePage(title: 'The Button App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _navigationIndex = 0;

  void _onNavigationBarItemTapped(int index) {
    setState(() {
      _navigationIndex = index;
    });
  }

  Widget callPage(int navigationIndex) {
    switch (navigationIndex) {
      case 0:
        return GamePage();
      case 1:
        return LeaderboardsPage();
      case 2:
        return ShopPage();

        break;
      default:
        return GamePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: Theme.of(context).textTheme.title),
      ),
      body: callPage(_navigationIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_checked),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_arrow_up),
            title: Text('Leaderboards'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Shop'),
          ),
        ],
        currentIndex: _navigationIndex,
        onTap: _onNavigationBarItemTapped,
      ),
    );
  }
}
