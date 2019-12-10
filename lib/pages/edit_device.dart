import 'package:casa/components/dialog.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/components/select_icon.dart';
import 'package:casa/pages/rooms.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditDevicePage extends StatefulWidget {
  @override
  _EditDevicePageState createState() => _EditDevicePageState();

  final dynamic homeId;
  final dynamic device;
  const EditDevicePage({Key key, this.homeId, this.device}): super(key: key);
}

class _EditDevicePageState extends State<EditDevicePage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  final deviceNameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> rooms = [];

  int selectedRoom = 0;
  String selectedIcon = 'lightbulbOutline';

  @override
  void initState() {
    super.initState();
    setState(() {
      deviceNameController.text = widget.device['name'];
    });
    request.getRooms(widget.homeId).then((_rooms) {
      setState(() {
        selectedIcon = widget.device['icon'];
        rooms = _rooms;
        selectedRoom = _rooms.map((room) => room['id']).toList().indexOf(widget.device['roomId']);
      });
    });

    
  }

  updateIcon(String name) {
    setState(() {
      selectedIcon = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MdiIcons.trashCanOutline,
              color: Colors.red,
            ),
            onPressed: () {
              dialogs.confirm(context, "You really want to delete " + widget.device['name'] + " device?", () async {
                await request.deleteDevice(widget.homeId, widget.device['roomId'], widget.device['id']);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RoomsPage(homeId: widget.homeId)),
                );
              });
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              child: SelectIcon(updateIcon, selectedIcon),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              alignment: Alignment.centerLeft,
              child: StyledTitle('Na_me'),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: deviceNameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                elevation: 20.0,
                shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            Container(
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            alignment: Alignment.centerLeft,
            child: StyledTitle('Ro_om'),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Material(
              child: FlatButton(
                padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                onPressed: () {
                  dialogs.select(context, 'Rooms', rooms.map((room) => room['name']).toList(), selectedRoom, (index) {
                    setState(() {
                      selectedRoom = index;
                    });
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      rooms.length > 0 ? rooms[selectedRoom]['name'] : "",
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    Icon(MdiIcons.menuDown)
                  ],
                ),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
              ),
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
              elevation: 20.0,
              shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
            )
          ),
            Container(
              margin: EdgeInsets.only(top: 40.0, right: 20.0),
              alignment: Alignment.centerRight,
              child: Container(
                height: 45,
                child: Material(
                  child: FlatButton(
                    padding: EdgeInsets.only(top: 4.0),
                    onPressed: () async {
                      var body = {
                        "name": deviceNameController.text,
                        "icon": selectedIcon,
                        "roomId": rooms[selectedRoom]['id'],
                      };
                      print(body);
                      try {
                        var result = await request.editDevice(widget.homeId, widget.device['roomId'], widget.device['id'], body);
                        widget.device['name'] = result['name'];
                        widget.device['icon'] = result['icon'];
                        widget.device['roomId'] = result['roomId'];
                      } catch (e) {
                        final snackBar = SnackBar(content: Text(e));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        return;
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Save',
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
            )
          ],
        )
      )
    );
  }
}
