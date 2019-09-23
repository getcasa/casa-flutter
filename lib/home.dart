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
  Dialogs dialogs = new Dialogs();

  @override
  void initState() {
    super.initState();
  }

  Future<Null> addRoom(String name) {
    return request.addRoom(widget.home['id'], { 'name': name }).then((room) {
      print(room);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(widget.home['name']),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (select) {
              switch (select) {
                case "add_room":
                  dialogs.input(context, 'Create a room', 'Name', addRoom);
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "add_room",
                  child: Text("Add room"),
                ),
                PopupMenuItem(
                  value: "add_device",
                  child: Text("Add device"),
                ),
                PopupMenuItem(
                  value: "settings",
                  child: Text("Settings"),
                )
              ];
            },
          ),
        ],
      ),
      body: Text('test')
    );
  }
}
