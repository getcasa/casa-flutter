import 'package:casa/dialog.dart';
import 'package:casa/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:casa/request.dart';

class HomePage extends StatefulWidget {
  @override

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<_HomePageState> _refreshIndicatorKey = new GlobalKey<_HomePageState>();
  SharedPreferences prefs;
  String token;
  Dialogs dialogs = new Dialogs();
  Request request = new Request();

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

  @override
  void dispose() {
    dialogs.dispose();
    super.dispose();
  }

  Future<Null> _refresh() {
    return request.getHomes().then((homes) {
      print(homes);
    });
  }

  Future<Null> addHome(String name) {
    return request.addHome({ 'name': name }).then((home) {
      print(home);
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
              dialogs.input(context, 'Create an home', 'Name', addHome);
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
