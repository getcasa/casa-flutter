import 'package:casa/components/dialog.dart';
import 'package:casa/components/styled_components.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddAutomationPage extends StatefulWidget {
  @override
  _AddAutomationPageState createState() => _AddAutomationPageState();

  final dynamic homeId;
  const AddAutomationPage({Key key, this.homeId}): super(key: key);
}

class _AddAutomationPageState extends State<AddAutomationPage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  final automationNameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> conditions = [];
  List<dynamic> devices = [];
  List<String> deviceNames = [];
  String test;
  int i = 0; 

  @override
  void initState() {
    super.initState();
    getRooms().then((_) {
      createBox();
    });
  }

  Future<Null> getRooms() async {
    List<dynamic> _rooms = await request.getRooms(widget.homeId);
    for (var i = 0; i < _rooms.length; i++) {
      var _devices = await request.getDevices(widget.homeId, _rooms[i]['id']);
      devices.addAll(_devices);
    }
    setState(() {
      devices = devices;
    });
  }

  createBox() {
    var index = i;
    print(i);
    print(index);
    deviceNames.add(devices[0]['name']);
    conditions.add({
      'device': devices[0]['name'],
      'box': StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  'If ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
                DropdownButton<String>(
                  items: devices.map((device) {
                    print(deviceNames[index]);
                    return new DropdownMenuItem<String>(
                      value: test,
                      child: new Text(device['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    print(index);
                    setState(() {
                      test = value;
                    });
                  },
                ),
                Text(
                  ' has a ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
                Container(
                  width: 90,
                  child: TextField(),
                ),
                Text(
                  ' ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
                Container(
                  width: 90,
                  child: TextField(),
                ),
              ],
            )
          );
        }
      )
    });
    setState(() {
      conditions = conditions;
      deviceNames = deviceNames;
      i++;
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
      body: Column(
        children: <Widget>[
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
                  controller: automationNameController,
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StyledTitle('Con_ditions'),
                Container(
                  width: 30,
                  height: 30,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                    padding: EdgeInsets.all(0),
                    child: Icon(MdiIcons.plus),
                    onPressed: () {
                      createBox();
                    },
                  )
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: conditions.length,
                itemBuilder: (context, index) {
                  return conditions[index]['box'];
                }
              )
            )
          )
        ],
      )
    );
  }
}
