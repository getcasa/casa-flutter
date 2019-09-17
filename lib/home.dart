import 'package:casa/signin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<_HomePageState> _refreshIndicatorKey = new GlobalKey<_HomePageState>();
  SharedPreferences prefs;
  String token;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((_prefs) {
      prefs = _prefs;

      token = prefs.getString('token');
      if (token == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
        return;
      }

      
    });
  }

  Future<dynamic> getHomes() async {
    var url = 'http://192.168.1.46:3000/v1/homes';
    var response = await http.get(url,
      headers: {HttpHeaders.authorizationHeader: 'Bearer '+token},
    );
    var parsedJson = json.decode(response.body);
    return parsedJson;
  }

  Future<Null> _refresh() {
    return getHomes().then((homes) {
      print(homes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Homes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Home',
            onPressed: () {
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: ListView(children: [
        ])
      ),
    );
  }
}
