import 'package:casa/pages/api_settings.dart';
import 'package:casa/pages/home.dart';
import 'package:casa/request.dart';
import 'package:casa/store/store.dart';
import 'package:casa/structs.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'signin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Request request = new Request();
  CasaStore store = CasaStore();

  @override
  void initState() {
    super.initState();
    request.init().then((conf) async {
      if (request.ips == null || request.ips.length == 0 || request.selectedEnv == null || request.selectedEnv > request.ips.length + 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => APISettings()),
        );
        return;
      }

      try {
        await request.checkServer();
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => APISettings()),
        );
        return;
      }

      if (request.tokens == null || request.tokens[request.selectedEnv] == null || request.tokens[request.selectedEnv] == '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
        return;
      }

      User _user;
      try {
        _user = await request.getUser('');
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
        return;
      }

      store.setUser(_user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(homeId: '')),
      );
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
