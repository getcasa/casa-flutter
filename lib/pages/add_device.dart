import 'package:casa/components/dialog.dart';
import 'package:casa/components/select_icon.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/pages/rooms.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => _AddDevicePageState();

  final dynamic homeId;
  final List<dynamic> rooms;
  final dynamic device;
  const AddDevicePage({Key key, this.homeId, this.rooms, this.device}): super(key: key);
}

class _AddDevicePageState extends State<AddDevicePage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  final deviceNameController = TextEditingController();
  String selectedIcon = 'lightbulbOutline';
  int selectedRoom = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
      ),
      body: ListView(
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
                  dialogs.select(context, 'Rooms', widget.rooms.map((room) => room['name']).toList(), selectedRoom, (index) {
                    setState(() {
                      selectedRoom = index;
                    });
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.rooms[selectedRoom]['name'],
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
                    try {
                      await request.addDevice(widget.homeId, widget.rooms[selectedRoom]['id'], {
                        'gatewayId': widget.device['gatewayId'],
                        'name': deviceNameController.text,
                        'physicalId': widget.device['physicalId'],
                        'physicalName': widget.device['physicalName'],
                        'config': '{}',
                        'plugin': widget.device['plugin'],
                        'icon': selectedIcon
                      });
                    } catch (e) {
                      final snackBar = SnackBar(content: Text(e));
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RoomsPage(homeId: widget.homeId)),
                    );
                  },
                  child: Text(
                    'Add',
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
        ],
      )
    );
  }
}
