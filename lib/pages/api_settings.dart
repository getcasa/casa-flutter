import 'package:casa/components/dialog.dart';
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
  Dialogs dialogs = new Dialogs();
  CasaStore store = CasaStore();
  final apiIPController = TextEditingController();
  List<String> ips = [];
  List<String> tokens = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      ips = request.prefs.getStringList('ips') != null ? request.prefs.getStringList('ips') : [];
      tokens = request.prefs.getStringList('tokens') != null ? request.prefs.getStringList('tokens') : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Text.rich(
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
          Container(
            margin: EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Material(
              child: ips.length == 0 ?
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Text("Server history empty")
                )
              : Column(
                children: ips.asMap().map((index, ip) {
                  return MapEntry(index, ListTile(
                    trailing: Icon(MdiIcons.arrowRight),
                    title: Text(ip),
                    onTap: () async {
                      await request.prefs.setInt("selectedEnv", index);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                      );
                    },
                    onLongPress: () {
                      dialogs.confirm(context, "You really want to delete " + ips[index] + " server?", () async {
                        if (tokens[index] != null && tokens[index] != '') {
                          await request.signout();
                        }
                        ips.removeAt(index);
                        tokens.removeAt(index);
                        await request.prefs.setStringList("ips", ips);
                        await request.prefs.setStringList("tokens", tokens);
                        setState(() {
                          ips = ips;
                          tokens = tokens;
                        });
                        if (request.selectedEnv == index) {
                          await request.prefs.setInt("selectedEnv", 0);
                        }
                      });
                    },
                  ));
                }).values.toList()
              ),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          if (apiIPController.text == '') return;
          ips.add(apiIPController.text);
          tokens.add('');
          await request.prefs.setStringList("ips", ips);
          await request.prefs.setStringList("tokens", tokens);
          await request.prefs.setInt("selectedEnv", ips.length - 1);
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
