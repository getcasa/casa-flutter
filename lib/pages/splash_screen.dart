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
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MdiIcons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => APISettings()),
              );
            },
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
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
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: (request.ips.length > 0) ? Text(
                'Connecting to ' + request.ips[request.selectedEnv] + '...',
                style: TextStyle(
                  color: Colors.white
                ),
              )
              : Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white
                )
              )
            )
          ],
        )
      ),
    );
  }
}
