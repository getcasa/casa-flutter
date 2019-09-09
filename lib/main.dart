import 'package:flutter/material.dart';
import 'signin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casa',
      theme: ThemeData(
        fontFamily: 'Manjari',
        primaryColor: Color.fromRGBO(255, 177, 66, 1),
        accentColor: Color.fromRGBO(255, 177, 66, 1),
      ),
      home: SignInPage(),
    );
  }
}
