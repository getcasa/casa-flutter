import 'package:casa/dialog.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:casa/bottomNavigation.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();

  final dynamic homeId;
  const RoomsPage({Key key, this.homeId}): super(key: key);
}

class _RoomsPageState extends State<RoomsPage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  List<dynamic> homes;
  int homeIndex = 0;
  String homeName = '';

  @override
  void initState() {
    super.initState();
    request.init().then((_token) {
      request.getHomes().then((_homes) {
        setState(() {
          homes = _homes['data'];
          if (widget.homeId != '') {
            homeIndex = homes.indexWhere((_home) => _home['id'] == widget.homeId);
          }
          homeName = homes[homeIndex]['name'];
        });
      });
      return;
    });
  }

  Future<Null> addRoom(String name) {
    return request.addRoom(homes[homeIndex]['id'], { 'name': name }).then((room) {
      print(room);
    });
  }

  Future<dynamic> _getRooms() async {
    var rooms = await request.getRooms(homes[homeIndex]['id']);
    return rooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(homeName),
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
          Flexible(
            flex: 1,
            child: FutureBuilder(
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
                return Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(0.0),
                  child: GridView.builder(
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
                                Text(
                                  snapshot.data['data'][index]['name'],
                                  textAlign: TextAlign.center,
                                )
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
                  )
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigation(1, homes[homeIndex]['id'])
    );
  }
}
