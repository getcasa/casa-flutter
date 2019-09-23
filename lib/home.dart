import 'package:casa/dialog.dart';
import 'package:casa/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:casa/request.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  final dynamic home;
  const HomePage({Key key, this.home}): super(key: key);
}

class _HomePageState extends State<HomePage> {
  Request request = new Request();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(widget.home['name']),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Settings',
            onPressed: () {},
          ),
        ],
      ),
      body: Text('test')
    );
  }
}
