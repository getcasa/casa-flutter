import 'package:casa/components/device_box.dart';
import 'package:casa/components/dialog.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/pages/room_settings.dart';
import 'package:casa/pages/select_plugin.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:casa/components/bottom_navigation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();

  final dynamic homeId;
  const RoomsPage({Key key, this.homeId}): super(key: key);
}

class _RoomsPageState extends State<RoomsPage> with TickerProviderStateMixin {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  List<dynamic> rooms = [];
  String roomName = '';
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  Future<Null> getRooms() async {
    List<dynamic> _rooms = await _getRooms();
    for (var i = 0; i < _rooms.length; i++) {
      var devices = await request.getDevices(widget.homeId, _rooms[i]['id']);
      print(devices);
      _rooms[i]['devices'] = devices;
    }
    setState(() {
      rooms = _rooms;
      _tabController = TabController(vsync: this, length: rooms.length);
    });
  }

  Future<Null> addRoom(String name) {
    return request.addRoom(widget.homeId, { 'name': name }).then((room) {
      getRooms();
    });
  }

  Future<dynamic> _getRooms() async {
    var rooms = await request.getRooms(widget.homeId);
    return rooms;
  }

  List<Widget> getRoomsWidgets() {
    return rooms.asMap().map((i, room) => 
      MapEntry(i, Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              margin: EdgeInsets.only(top: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(
                room['name'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              margin: EdgeInsets.only(top: 40.0),
              alignment: Alignment.centerLeft,
              child: StyledTitle('Dev_ices')
            ),
            Flexible(
              flex: 1,
              child: Container(
                height: double.infinity,
                child: GridView.builder(
                  padding: EdgeInsets.all(20.0),
                  shrinkWrap: true,
                  itemCount: rooms[i]['devices'].length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.0,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var device = rooms[i]['devices'][index];

                    return DeviceBox(device['name'], device['icon'], false, () async {
                      if (device['defaultAction'] == null || device['defaultAction'] == '') return;
                      await request.callAction(widget.homeId, rooms[i]['id'], device['id'], {
                        'action': device['defaultAction']
                      });
                    });
                  },
                ),
              )
            )
          ],
        ))
      )).values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.list, color: Colors.black),
          onPressed: () {
            List<dynamic> names = rooms.map((home) => home['name']).toList();
            int index = _tabController != null ? _tabController.index : 0;
            dialogs.select(context, 'Rooms', names, index, (index) {
              _tabController.animateTo(index);
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
                case "add_device":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SelectPluginPage(homeId: widget.homeId, rooms: rooms)),
                  );
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "create_room",
                  child: Text("Create room"),
                ),
                PopupMenuItem(
                  value: "add_device",
                  child: Text("Add device"),
                ),
              ];
            },
          ),
          PopupMenuButton(
            onSelected: (select) {
              switch (select) {
                case "room_settings":
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RoomSettingsPage(homeId: widget.homeId, room: rooms[_tabController.index])),
                  );
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "room_settings",
                  child: Text("Room settings"),
                )
              ];
            },
          ),
        ],
      ),
      body: rooms == null || rooms.length == 0
        ? Center(
            child: rooms.length == 0
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "There is no room in your "
                        ),
                        TextSpan(
                          text: "Home",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    alignment: Alignment.center,
                    child: Container(
                      height: 45,
                      child: Material(
                        child: FlatButton(
                          padding: EdgeInsets.only(top: 4.0),
                          onPressed: () {
                            dialogs.input(context, 'Create a room', 'Name', addRoom);
                          },
                          child: Text(
                            'Add room',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            )
                          ),
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                        ),
                        color: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                        elevation: 20.0,
                        shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    )
                  ),
                ]
              )
              : CircularProgressIndicator()
          )
        : DefaultTabController(
          length: rooms.length,
          child: TabBarView(
            controller: _tabController,
            children: getRoomsWidgets()
          ),
        ),
      bottomNavigationBar: BottomNavigation(1, widget.homeId)
    );
  }
}
