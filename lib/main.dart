import 'package:button_app/models/user.dart';
import 'package:button_app/pages/home.dart';
import 'package:button_app/pages/signin.dart';
import 'package:button_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          title: 'Button App',
          theme: ThemeData(
            primaryColor: Color(0xFF01A39D),
            accentColor: Colors.grey[700],
            textTheme: TextTheme(
                headline6: TextStyle(color: Colors.white),
                bodyText2: TextStyle(color: Colors.grey[700]),
                headline4: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 29.0,
                    fontWeight: FontWeight.w400),
                headline1: TextStyle(
                    color: Color(0xFF01A39D),
                    fontWeight: FontWeight.w400,
                    fontSize: 90.0),
                caption: TextStyle(color: Colors.grey[700]),
                button: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.grey[700]),
          ),
          home: MainPage(),
//      home: MyHomePage(title: 'The Button App'),
        ));
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print('In MainPage');
    print(user);
    return (user == null) ? SignIn() : Home(title: 'The Button App');
//    return Home(title: 'The Button App');
  }
}
