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
  List<dynamic> triggerDevices = [];
  List<dynamic> actionDevices = [];

  @override
  void initState() {
    super.initState();
    getRooms().then((_) {
      createCondition();
    });
  }

  Future<Null> getRooms() async {
    List<dynamic> devices = [];
    List<dynamic> _rooms = await request.getRooms(widget.homeId);
    for (var i = 0; i < _rooms.length; i++) {
      var _devices = await request.getDevices(widget.homeId, _rooms[i]['id']);
      devices.addAll(_devices);
    }
    setState(() {
      triggerDevices = devices.where((device) => device['pluginDevice']['triggers'] != null && device['pluginDevice']['triggers'].length > 0).toList();
      actionDevices = devices.where((device) => device['pluginDevice']['actions'] != null && device['pluginDevice']['actions'].length > 0).toList();
    });
  }

  createCondition() {
    conditions.add({
      'deviceName': triggerDevices[0]['name'],
      'deviceField': triggerDevices[0]['pluginDevice']['triggers'][0]['name'],
      'deviceValue': null
    });
    setState(() {
      conditions = conditions;
    });
  }

  Widget deviceValueInput(dynamic condition, int index) {
    var trigger = triggerDevices.firstWhere((device) => device['name'] == condition['deviceName'])['pluginDevice']['triggers'].firstWhere((trigger) => trigger['name'] == condition['deviceField']);
    print(trigger);
    switch (trigger['type']) {
      case 'string':
        if (trigger['possibilities'] == null || trigger['possibilities'].length == 0) {
          return TextField();
        }
        if (condition['deviceValue'] == null) condition['deviceValue'] = trigger['possibilities'][0];
        return DropdownButton<String>(
          value: condition['deviceValue'],
          items: trigger['possibilities'].map<DropdownMenuItem<String>>((possibility) {
            return DropdownMenuItem<String>(
              value: possibility,
              child: Text(possibility),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              conditions[index]['deviceValue'] = value;
            });
          },
        );
        break;
      case 'int':
        if (trigger['possibilities'] == null || trigger['possibilities'].length == 0) {
          return TextField(
            keyboardType: TextInputType.number,
          );
        }
        if (condition['deviceValue'] == null) condition['deviceValue'] = trigger['possibilities'][0];
        return DropdownButton<String>(
          value: condition['deviceValue'],
          items: trigger['possibilities'].map<DropdownMenuItem<String>>((possibility) {
            return DropdownMenuItem<String>(
              value: possibility,
              child: Text(possibility),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              conditions[index]['deviceValue'] = value;
            });
          },
        );
        break;
      case 'bool':
        if (condition['deviceValue'] == null) condition['deviceValue'] = trigger['possibilities'][0];
        return DropdownButton<String>(
          value: condition['deviceValue'],
          items: ['true', 'false'].map<DropdownMenuItem<String>>((possibility) {
            return DropdownMenuItem<String>(
              value: possibility,
              child: Text(possibility),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              conditions[index]['deviceValue'] = value;
            });
          },
        );
        break;
      default:
        return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        height: double.infinity,
        child: ListView(
          shrinkWrap: true,
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
                        createCondition();
                      },
                    )
                  )
                ],
              ),
            ),
            Column(
              children: conditions.asMap().map((i, condition) {
                return MapEntry(i, Wrap(
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
                      value: condition['deviceName'],
                      items: triggerDevices.map<DropdownMenuItem<String>>((device) {
                        return DropdownMenuItem<String>(
                          value: device['name'],
                          child: Text(device['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          conditions[i]['deviceName'] = value;
                          conditions[i]['deviceField'] = triggerDevices[triggerDevices.indexWhere((device) => device['name'] == value)]['pluginDevice']['triggers'][0]['name'];
                          conditions[i]['deviceValue'] = null;
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
                    DropdownButton<String>(
                      value: condition['deviceField'],
                      items: triggerDevices[triggerDevices.indexWhere((device) => device['name'] == condition['deviceName'])]['pluginDevice']['triggers'].map<DropdownMenuItem<String>>((trigger) {
                        return DropdownMenuItem<String>(
                          value: trigger['name'],
                          child: Text(trigger['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          conditions[i]['deviceField'] = value;
                          conditions[i]['deviceValue'] = null;
                        });
                      },
                    ),
                    Text(
                      ' ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    deviceValueInput(condition, i)
                  ],
                ));
              }).values.toList(),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StyledTitle('Act_ions'),
                  Container(
                    width: 30,
                    height: 30,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                      padding: EdgeInsets.all(0),
                      child: Icon(MdiIcons.plus),
                      onPressed: () {
                        setState(() {
                          conditions[0]['deviceName'] = 'test';
                        });
                        // createCondition();
                      },
                    )
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}
