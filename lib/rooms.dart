import 'package:casa/dialog.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:casa/bottom_navigation.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();

  final dynamic homeId;
  const RoomsPage({Key key, this.homeId}): super(key: key);
}

class _RoomsPageState extends State<RoomsPage> with SingleTickerProviderStateMixin {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  List<dynamic> rooms;
  String roomName = '';
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    request.init().then((_token) {
      _getRooms().then((_rooms) {
        setState(() {
          rooms = _rooms['data'];
          _tabController = TabController(vsync: this, length: rooms.length);
        });
      });
      return;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<Null> addRoom(String name) {
    return request.addRoom(widget.homeId, { 'name': name }).then((room) {
      print(room);
    });
  }

  Future<dynamic> _getRooms() async {
    var rooms = await request.getRooms(widget.homeId);
    return rooms;
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
      body: rooms == null || rooms.length == 0
        ? Center(
          child: CircularProgressIndicator(),
        )
        : DefaultTabController(
          length: rooms.length,
          child: TabBarView(
            controller: _tabController,
            children: rooms.map((room) {
              return Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Container(
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
                      margin: EdgeInsets.only(top: 40.0),
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Dev',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(context).accentColor,
                                decorationThickness: 2.0
                              )
                            ),
                            TextSpan(
                              text: 'ices'
                            ),
                          ],
                        ),
                      )
                    )
                  ],
                )
              );
            }).toList()
          ),
        ),
      bottomNavigationBar: BottomNavigation(1, widget.homeId)
    );
  }
}
