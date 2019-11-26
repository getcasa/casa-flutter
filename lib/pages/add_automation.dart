import 'dart:convert';

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
  List<String> triggerOperators = [];
  List<dynamic> actionDevices = [];
  List<dynamic> actions = [];

  @override
  void initState() {
    super.initState();
    getRooms().then((_) {
      createCondition();
      createAction();
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
      'deviceId': triggerDevices[0]['id'],
      'deviceName': triggerDevices[0]['name'],
      'deviceField': triggerDevices[0]['pluginDevice']['triggers'][0]['name'],
      'deviceValue': null,
      'deviceValueOperator': triggerDevices[0]['pluginDevice']['triggers'][0]['type'] == 'int' ? '=' : ''
    });
    setState(() {
      conditions = conditions;
    });
  }

  createAction() {
    actions.add({
      'deviceId': actionDevices[0]['id'],
      'deviceName': actionDevices[0]['name'],
      'deviceAction': actionDevices[0]['pluginActions'][0]['name'],
      'deviceValues': {}
    });
    setState(() {
      actions = actions;
    });
  }

  Widget deviceValueInput(dynamic condition, int index) {
    var trigger = triggerDevices.firstWhere((device) => device['id'] == condition['deviceId'])['pluginDevice']['triggers'].firstWhere((trigger) => trigger['name'] == condition['deviceField']);

    switch (trigger['type']) {
      case 'string':
        if (trigger['possibilities'] == null || trigger['possibilities'].length == 0) {
          return TextField(
            onChanged: (value) {
              setState(() {
                conditions[index]['deviceValue'] = value;
              });
            },
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
      case 'int':
        if (trigger['possibilities'] == null || trigger['possibilities'].length == 0) {
          return Wrap(
            children: <Widget>[
              DropdownButton<String>(
                value: condition['deviceValueOperator'],
                items: ['=', '!=', '>', '>=', '<', '<='].map<DropdownMenuItem<String>>((possibility) {
                  return DropdownMenuItem<String>(
                    value: possibility,
                    child: Text(possibility),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    conditions[index]['deviceValueOperator'] = value;
                  });
                },
              ),
              Container(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      conditions[index]['deviceValue'] = value;
                    });
                  },
                )
              )
            ]
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

  Widget deviceValuesInputs(dynamic action, int index) {
    var actionDevice = actionDevices.firstWhere((device) => device['id'] == action['deviceId']);
    var deviceAction = actionDevice['pluginActions'].firstWhere((_action) => _action['name'] == action['deviceAction']);
    if (deviceAction['fields'] == null || deviceAction['fields'].length == 0) {
      return Container();
    }
    List<Widget> children = [
      Text(
        ' with ',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        )
      )
    ];
    for (var i = 0; i < deviceAction['fields'].length; i++) {
      switch (deviceAction['fields'][i]['type']) {
        case 'string':
          children.add(
            TextField(
              decoration: InputDecoration(
                hintText: deviceAction['fields'][i]['name']
              ),
              onChanged: (value) {
                setState(() {
                  actions[index]['deviceValues'][deviceAction['fields'][i]['name']] = value;
                });
              },
            )
          );
          break;
        case 'int':
          children.add(
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: deviceAction['fields'][i]['name']
              ),
              onChanged: (value) {
                setState(() {
                  actions[index]['deviceValues'][deviceAction['fields'][i]['name']] = int.parse(value);
                });
              },
            )
          );
          break;
        case 'bool':
          children.add(
            DropdownButton<bool>(
              value: actions[index]['deviceValues'][deviceAction['fields'][i]['name']],
              items: [true, false].map<DropdownMenuItem<bool>>((possibility) {
                return DropdownMenuItem<bool>(
                  value: possibility,
                  child: Text(possibility.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  actions[index]['deviceValues'][deviceAction['fields'][i]['name']] = value;
                });
              },
            )
          );
          break;
        default:
      }
    }
    return Wrap(
      children: children,
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
                        triggerOperators.add("AND");
                        setState(() {
                          triggerOperators = triggerOperators;
                        });
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
                      'When ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    DropdownButton<String>(
                      value: condition['deviceId'],
                      items: triggerDevices.map<DropdownMenuItem<String>>((device) {
                        return DropdownMenuItem<String>(
                          value: device['id'],
                          child: Text(device['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        var device = triggerDevices.firstWhere((device) => device['id'] == value);
                        setState(() {
                          conditions[i]['deviceId'] = value;
                          conditions[i]['deviceName'] = device['name'];
                          conditions[i]['deviceField'] = device['pluginDevice']['triggers'][0]['name'];
                          conditions[i]['deviceValue'] = null;
                          conditions[i]['deviceValueOperator'] = device['pluginDevice']['triggers'][0]['type'] == 'int' ? '=' : '';
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
                      items: triggerDevices.firstWhere((device) => device['id'] == condition['deviceId'])['pluginDevice']['triggers'].map<DropdownMenuItem<String>>((trigger) {
                        return DropdownMenuItem<String>(
                          value: trigger['name'],
                          child: Text(trigger['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        var device = triggerDevices.firstWhere((device) => device['id'] == condition['deviceId']);
                        setState(() {
                          conditions[i]['deviceField'] = value;
                          conditions[i]['deviceValue'] = null;
                          conditions[i]['deviceValueOperator'] = device['pluginDevice']['triggers'].firstWhere((trigger) => trigger['name'] == value)['type'] == 'int' ? '=' : '';
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
                    deviceValueInput(condition, i),
                    (conditions.length > 1 && conditions.length != i + 1) ?
                      DropdownButton<String>(
                        value: triggerOperators[i],
                        items: ['AND', 'OR'].map<DropdownMenuItem<String>>((triggerOperator) {
                          return DropdownMenuItem<String>(
                            value: triggerOperator,
                            child: Text(triggerOperator),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            triggerOperators[i] = value;
                          });
                        },
                      ) : Container()
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
                        createAction();
                      },
                    )
                  )
                ],
              ),
            ),
            Column(
              children: actions.asMap().map((i, action) {
                return MapEntry(i, Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      'Do on ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    DropdownButton<String>(
                      value: action['deviceId'],
                      items: actionDevices.map<DropdownMenuItem<String>>((device) {
                        return DropdownMenuItem<String>(
                          value: device['id'],
                          child: Text(device['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        var device = actionDevices.firstWhere((device) => device['id'] == value);
                        setState(() {
                          actions[i]['deviceId'] = value;
                          actions[i]['deviceName'] = device['name'];
                          actions[i]['deviceAction'] = device['pluginActions'][0]['name'];
                          actions[i]['deviceValues'] = {};
                        });
                      },
                    ),
                    Text(
                      ' action ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    DropdownButton<String>(
                      value: action['deviceAction'],
                      items: actionDevices.firstWhere((device) => device['id'] == action['deviceId'])['pluginActions'].map<DropdownMenuItem<String>>((action) {
                        return DropdownMenuItem<String>(
                          value: action['name'],
                          child: Text(action['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          actions[i]['deviceAction'] = value;
                          actions[i]['deviceValues'] = {};
                        });
                      },
                    ),
                    deviceValuesInputs(action, i)
                  ],
                ));
              }).values.toList(),
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
                        "name": automationNameController.text,
                        "trigger": conditions.map((condition) => condition['deviceId']).toList(),
                        "triggerKey": conditions.map((condition) => condition['deviceField']).toList(),
                        "triggerValue": conditions.map((condition) => condition['deviceValueOperator'] + condition['deviceValue']).toList(),
                        "triggerOperator": triggerOperators,
                        "action": actions.map((action) => action['deviceId']).toList(),
                        "actionCall": actions.map((action) => action['deviceAction']).toList(),
                        "actionValue": actions.map((action) => json.encode(action['deviceValues'])).toList(),
                        "status": true
                      };
                      try {
                        await request.addAutomation(widget.homeId, body);
                      } catch (e) {
                        final snackBar = SnackBar(content: Text(e));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        return;
                      }
                      // Navigator.pop(context);
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
      )
    );
  }
}
