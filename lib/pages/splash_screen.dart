import 'package:casa/pages/home.dart';
import 'package:casa/request.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'signin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Request request = new Request();

  @override
  void initState() {
    super.initState();
    request.init().then((_token) {
      if (_token == '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
        return;
      }
      request.getUser('').then((_user) {
        print(_user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(homeId: '')),
        );
      }).catchError((err) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      });
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Theme.of(context).accentColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              MdiIcons.homeOutline,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                strokeWidth: 4,
              )
            )
          ],
        )
      ),
    );
  }
}
