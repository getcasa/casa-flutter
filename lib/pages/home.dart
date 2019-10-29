import 'package:casa/components/dialog.dart';
import 'package:casa/pages/home_settings.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/pages/on_boarding.dart';
import 'package:casa/pages/user_settings.dart';
import 'package:casa/store/store.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:casa/components/bottom_navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  final dynamic homeId;
  const HomePage({Key key, this.homeId}): super(key: key);
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  CasaStore store = CasaStore();

  List<dynamic> homes;
  int homeIndex = 0;
  String homeName = '';
  String homeId = '';

  @override
  void initState() {
    super.initState();
    request.init().then((_token) {
      _getHomes(widget.homeId);
      return;
    });
  }

  _getHomes(_homeId) {
    request.getHomes().then((_homes) {
      if (_homes['data'] == null || _homes['data'].length == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingPage()),
        );
      }

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

  Future<dynamic> _addRoom(String name) {
    return request.addRoom(homes[homeIndex]['id'], { 'name': name }).then((data) {
      final snackBar = SnackBar(content: Text(name + ' has been created'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }).catchError((err) {
      final snackBar = SnackBar(content: Text(err));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  Future<dynamic> _addHome(String name) {
    return request.addHome({ 'name': name }).then((data) {
      final snackBar = SnackBar(content: Text(name + ' has been created'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      _getHomes(data['message']);
    }).catchError((err) {
      final snackBar = SnackBar(content: Text(err));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  dialogs.input(context, 'Create a room', 'Name', _addRoom);
                  break;
                case "create_home":
                  dialogs.input(context, 'Create an home', 'Name', _addHome);
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
                case "user_settings":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserSettingsPage()),
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
                  value: "user_settings",
                  child: Text("My account"),
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
            child: Observer(
              name: 'username',
              builder: (_) => Text(
                'Hello ${store.getUsername},',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54
                ),
              )
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
            child: StyledTitle('Sho_rtcuts')
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(0, homeId)
    );
  }
}
