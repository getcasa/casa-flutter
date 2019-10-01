import 'package:casa/dialog.dart';
import 'package:casa/home_settings.dart';
import 'package:casa/styled_components.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:casa/bottom_navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
      getHomes(widget.homeId);
      return;
    });
  }

  getHomes(_homeId) {
    request.getHomes().then((_homes) {
      setState(() {
        homes = _homes['data'];
        homeId = homes[0]['id'];
        if (_homeId != '') {
          homeIndex = homes.indexWhere((_home) => _home['id'] == _homeId);
          homeId = _homeId;
        }
        homeName = homes[homeIndex]['name'];
      });
    });
  }

  Future<Null> addRoom(String name) {
    return request.addRoom(homes[homeIndex]['id'], { 'name': name }).then((room) {});
  }

  Future<Null> addHome(String name) {
    return request.addHome({ 'name': name }).then((home) {
      getHomes(home['message']);
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
          icon: Icon(MdiIcons.homeOutline),
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
            icon: Icon(Icons.add),
            onSelected: (select) {
              switch (select) {
                case "create_room":
                  dialogs.input(context, 'Create a room', 'Name', addRoom);
                  break;
                case "create_home":
                  dialogs.input(context, 'Create an home', 'Name', addHome);
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "add_device",
                  child: Text("Add device"),
                ),
                PopupMenuItem(
                  value: "create_room",
                  child: Text("Create room"),
                ),
                PopupMenuItem(
                  value: "create_home",
                  child: Text("Create home"),
                )
              ];
            },
          ),
          PopupMenuButton(
            onSelected: (select) {
              switch (select) {
                case "home_settings":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeSettingsPage(home: homes[homeIndex])),
                  );
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              PopupMenuItem<String> _popupMenuItem;
              if (homes[homeIndex]['manage'] == 1 || homes[homeIndex]['admin'] == 1) {
                _popupMenuItem = PopupMenuItem(
                  value: "home_settings",
                  child: Text("Home settings"),
                );
              }
              return [
                _popupMenuItem,
                PopupMenuItem(
                  value: "app_settings",
                  child: Text("App settings"),
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
            child: StyledTitle('Fav_orites')
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(0, homeId)
    );
  }
}
