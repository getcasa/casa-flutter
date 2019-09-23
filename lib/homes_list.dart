import 'package:casa/dialog.dart';
import 'package:casa/home.dart';
import 'package:casa/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:casa/request.dart';

class HomesListPage extends StatefulWidget {
  @override

  _HomesListPageState createState() => _HomesListPageState();
}

class _HomesListPageState extends State<HomesListPage> {
  final GlobalKey<_HomesListPageState> _refreshIndicatorKey = new GlobalKey<_HomesListPageState>();
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

  Future<dynamic> _refresh() async {
    var homes = await request.getHomes();
    // print(homes);
    return homes;
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
        child: FutureBuilder(
          future: _refresh(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Text('Loading ...');
            }
            return ListView.builder(
              itemCount: snapshot.data['data'].length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data['data'][index]['name']),
                  subtitle: Text(snapshot.data['data'][index]['address']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage(home: snapshot.data['data'][index])),
                    );
                  },
                );
              },
            );
          },
        )
      ),
    );
  }
}
