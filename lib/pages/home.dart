import 'package:button_app/pages/shop.dart';
import 'package:button_app/services/auth.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'leaderboards.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _navigationIndex = 0;
  final AuthService _authService = AuthService();

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
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _authService.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('Logout')),
          FlatButton.icon(
              onPressed: () {},
              icon: Icon(Icons.settings),
              label: Text('Settings'))
        ],
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
