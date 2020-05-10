import 'package:button_app/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  String email = 'm@m.com';
  String password = 'warmSummer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child:Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: email,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                initialValue: password,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.blue[500],
                child: Text('Sign in', style: TextStyle(color:Colors.white),),
                onPressed: () {
//                  print('email');
//                  print(email);
//                  print('password');
//                  print(password);
//                  _authService.signInEmail(email, password);
                  _authService.signInWithGoogle();
                },
              )
            ],
          )
        ),
      ),
    );
  }
}