import 'package:casa/components/dialog.dart';
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

  showIconsList() {
    var icons = MdiIcons.getIconsName();

    var updateIcon = (String name) {
      setState(() {
        selectedIcon = name;
      });
    };

    var changeIconList = (String value) {
      icons =  MdiIcons.getIconsName().where((elem) => elem.contains(value)).toList();
    };

    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Find an icon...'
                ),
                onChanged: (String value) {
                  changeIconList(value);
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: GridView.builder(
                padding: EdgeInsets.all(20.0),
                shrinkWrap: true,
                itemCount: icons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0
                ),
                itemBuilder: (BuildContext context, int index) {
                  var icon = MdiIcons.fromString(icons[index]);
                  var isSelected = icons[index] == selectedIcon;

                  return Material(
                    child: FlatButton(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      onPressed: () {
                        updateIcon(icons[index]);
                        Navigator.pop(context);
                      },
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                    elevation: 20.0,
                    shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                    color: isSelected ? Theme.of(context).accentColor : Colors.white,
                  );
                },
              )
            )
          ]
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0)
        )
      ),
    );
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
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20.0),
            child: Material(
              child: FlatButton(
                padding: EdgeInsets.all(10),
                onPressed: () {
                  showIconsList();
                },
                child: Icon(
                  MdiIcons.fromString(selectedIcon),
                  size: 80,
                ),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
              ),
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
              elevation: 20.0,
              shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
            )
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              'Choose icon...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54
              )
            )
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
