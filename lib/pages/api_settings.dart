import 'package:casa/pages/splash_screen.dart';
import 'package:casa/request.dart';
import 'package:casa/store/store.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class APISettings extends StatefulWidget {
  @override
  _APISettingsState createState() => _APISettingsState();
}

class _APISettingsState extends State<APISettings> {
  Request request = new Request();
  CasaStore store = CasaStore();
  final apiIPController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var _apiIP = request.prefs.getString('apiIP');
    if (_apiIP != null && _apiIP != '') {
      setState(() {
        apiIPController.text = _apiIP;
      });
    }
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
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Locate your "
                  ),
                  TextSpan(
                    text: "Casa Server",
                    style: TextStyle(
                      color: Colors.white,
                    )
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                right: 20.0,
                left: 20.0
              ),
              margin: EdgeInsets.only(top: 20.0),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: apiIPController,
                    decoration: InputDecoration(
                      hintText: 'localhost:4353',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                elevation: 20.0,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          request.apiIP = apiIPController.text;
          await request.prefs.setString("apiIP", apiIPController.text);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
        },
        child: Icon(
          MdiIcons.chevronRight,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
