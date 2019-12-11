import 'package:casa/components/dialog.dart';
import 'package:casa/components/edit_title.dart';
import 'package:casa/components/select_icon.dart';
import 'package:casa/pages/rooms.dart';
import 'package:casa/store/store.dart';
import 'package:casa/request.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

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
  CasaStore store = CasaStore();
  final deviceNameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> rooms = [];
  List<dynamic> permissionsOptions = [];

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

  Future<dynamic> _getDeviceMembers() async {
    var response = await request.getDeviceMembers(widget.homeId, widget.device['roomId'], widget.device['id']);
    return response;
  }

  showEditPermissionsModal(String userId, List options) {
    List<dynamic> _initPermissions = options.map((option) {
      return option['value'];
    }).toList();
    permissionsOptions = [];
    permissionsOptions.addAll(_initPermissions);
    setState(() {});
    
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: permissionsOptions.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return ListTile(
                        trailing: Switch(
                          value: permissionsOptions[index],
                          onChanged: (value) {
                            setModalState(() {
                              permissionsOptions[index] = value;
                            });
                          }
                        ),
                        title: Text(options[index]['name'])
                      );
                    }
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        textColor: Theme.of(context).accentColor,
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        textColor: Theme.of(context).accentColor,
                        child: Text('Save'),
                        onPressed: () async {
                          var response;
                          try {
                            response = await request.editDeviceMember(
                              widget.homeId,
                              widget.device['roomId'],
                              userId,
                              widget.device['id'],
                              {
                                'read': permissionsOptions[0],
                                'write': permissionsOptions[1],
                                'manage': permissionsOptions[2],
                                'admin': permissionsOptions[3],
                              }
                            );
                            
                          } catch (e) {
                            final snackBar = SnackBar(content: Text(e));
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                            return;
                          }
                          setState(() {});
                          Navigator.pop(context);
                          final snackBar = SnackBar(content: Text(response['message']));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                      )
                    ],
                  )
                ]
              )
            );
          }
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
            EditTitle('Na_me'),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              margin: EdgeInsets.only(top: 20.0),
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
            EditTitle('Ro_om'),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0),
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
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              margin: EdgeInsets.only(top: 50.0),
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
            ),
            EditTitle('Mem_bers'),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: FutureBuilder(
                future: _getDeviceMembers(),
                builder: (context, projectSnap) {
                  if (projectSnap == null || projectSnap.data == null) {
                    return CircularProgressIndicator();
                  }
                  return Column(
                    children: List<Widget>.generate(projectSnap.data.length, (index) {
                      var user = projectSnap.data[index];
                      var gravatar = Gravatar(user['email']);
                      var url = gravatar.imageUrl(
                        size: 100,
                        defaultImage: GravatarImage.retro,
                        rating: GravatarRating.pg,
                        fileExtension: true,
                      );

                      var isOwner = user['id'] == widget.device['creator']['id'];
                      var isMe = user['id'] == store.user.id;
                      var borderColor = isOwner ? Theme.of(context).accentColor : Colors.transparent;

                      return Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 27,
                                backgroundColor: borderColor,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(url),
                                ),
                              ),
                              title: Text(
                                user['firstname'] + ' ' + user['lastname'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: !isOwner && !isMe ? IconButton(
                                icon: Icon(user['read'] == true ? MdiIcons.eyeOutline : MdiIcons.eyeOffOutline),
                                tooltip: 'Edit',
                                onPressed: () {
                                  var options = [
                                    {
                                      'name': 'read',
                                      'value': user['read']
                                    },
                                    {
                                      'name': 'write',
                                      'value': user['write']
                                    },
                                    {
                                      'name': 'manage',
                                      'value': user['manage']
                                    },
                                    {
                                      'name': 'admin',
                                      'value': user['admin']
                                    }
                                  ];
                                  showEditPermissionsModal(user['id'], options);
                                },
                              ) : null
                            )
                          );
                    })
                  );
                },
              ),
            )
          ],
        )
      )
    );
  }
}
