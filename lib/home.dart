import 'package:casa/dialog.dart';
import 'package:flutter/material.dart';
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
    request.init().then((_token) {
      return;
    });
  }

  Future<Null> addRoom(String name) {
    return request.addRoom(widget.home['id'], { 'name': name }).then((room) {
      print(room);
    });
  }

  Future<dynamic> _getRooms() async {
    var rooms = await request.getRooms(widget.home['id']);
    return rooms;
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
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Rooms',
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).accentColor,
                fontSize: 18
              ),
            ),
          ),
          FutureBuilder(
            future: _getRooms(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // print(snapshot);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator()
                );
              }
              if (snapshot.data == null) {
                return Text('No rooms');
              }
              return GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['data'].length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(20.0),
                    child: Material(
                      child: FlatButton(
                        onPressed: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.black,
                              size: 50.0,
                            ),
                            Text(snapshot.data['data'][index]['name'])
                          ]
                        ),
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                      elevation: 20.0,
                      shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }
              );
            },
          ),
        ],
      )
    );
  }
}
