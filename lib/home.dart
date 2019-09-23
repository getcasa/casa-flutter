import 'package:casa/dialog.dart';
import 'package:casa/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:casa/request.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  final String homeId;
  const HomePage({Key key, this.homeId}): super(key: key);
}

class _HomePageState extends State<HomePage> {
  Request request = new Request();

  @override
  void initState() {
    super.initState();

    print(widget.homeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Homes'),
        actions: <Widget>[],
      ),
      body: Text('test')
    );
  }
}
