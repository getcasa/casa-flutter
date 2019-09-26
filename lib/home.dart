import 'package:casa/dialog.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:casa/bottomNavigation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  final dynamic homeId;
  const HomePage({Key key, this.homeId}): super(key: key);
}

class _HomePageState extends State<HomePage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  List<dynamic> homes;
  int homeIndex = 0;
  String homeName = '';
  String homeId = '';
  String userName = 'Jimi';

  @override
  void initState() {
    super.initState();
    request.init().then((_token) {
      request.getHomes().then((_homes) {
        setState(() {
          homes = _homes['data'];
          homeId = homes[0]['id'];
          if (widget.homeId != '') {
            homeIndex = homes.indexWhere((_home) => _home['id'] == widget.homeId);
            homeId = widget.homeId;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.black),
          onPressed: () {
            List<dynamic> names = homes.map((home) => home['name']).toList();
            dialogs.select(context, 'My homes', names, homeIndex, (index) {
              setState(() {
                homeIndex = index;
                homeName = homes[homeIndex]['name'];
                homeId = homes[homeIndex]['id'];
              });
            });
          },
        ),
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
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Hello $userName,',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54
              ),
            )
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '0',
                    style: TextStyle(
                      color: Theme.of(context).accentColor
                    )
                  ),
                  TextSpan(
                    text: ' people in '
                  ),
                  TextSpan(
                    text: homeName,
                    style: TextStyle(
                      color: Theme.of(context).accentColor
                    )
                  ),
                ],
              ),
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 40.0),
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Fav',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).accentColor
                    )
                  ),
                  TextSpan(
                    text: 'orites'
                  ),
                ],
              ),
            )
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(0, homeId)
    );
  }
}
