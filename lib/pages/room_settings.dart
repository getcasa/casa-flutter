import 'package:casa/components/dialog.dart';
import 'package:casa/pages/home.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/pages/rooms.dart';
import 'package:casa/store/store.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

class RoomSettingsPage extends StatefulWidget {
  @override
  _RoomSettingsPageState createState() => _RoomSettingsPageState();

  final dynamic homeId;
  final dynamic room;
  const RoomSettingsPage({Key key, this.homeId, this.room}): super(key: key);
}

class _RoomSettingsPageState extends State<RoomSettingsPage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  CasaStore store = CasaStore();
  final roomNameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> permissionsOptions = [];

  @override
  void initState() {
    super.initState();
    roomNameController.text = widget.room['name'];
    request.init().then((_token) {
      return;
    });
  }

  Future<dynamic> _getRoomMembers() async {
    var response = await request.getRoomMembers(widget.homeId, widget.room['id']);
    return response;
  }

  Future<Null> _deleteRoom() async {
    try {
      await request.deleteRoom(widget.homeId, widget.room['id']);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RoomsPage(homeId: widget.homeId,)),
    );
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
                            response = await request.editRoomMember(
                              widget.homeId,
                              widget.room['id'],
                              userId,
                              {
                                'read': permissionsOptions[0].toString(),
                                'write': permissionsOptions[1].toString(),
                                'manage': permissionsOptions[2].toString(),
                                'admin': permissionsOptions[3].toString(),
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
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MdiIcons.trashCanOutline,
              color: Colors.red,
            ),
            onPressed: () {
              dialogs.confirm(context, "You really want to delete " + widget.room['name'] + " and all datas?", () async {
                await _deleteRoom();
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20.0),
              alignment: Alignment.centerLeft,
              child: StyledTitle('Set_tings')
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: roomNameController,
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
              margin: EdgeInsets.only(top: 10.0),
              alignment: Alignment.centerRight,
              child: Container(
                height: 45,
                child: Material(
                  child: FlatButton(
                    padding: EdgeInsets.only(top: 4.0),
                    onPressed: () async {
                      var response;
                        try {
                          response = await request.editRoom(widget.homeId, widget.room['id'], {
                            'name': roomNameController.text,
                          });
                        } catch (e) {
                          final snackBar = SnackBar(content: Text(e));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                          return;
                        }
                        final snackBar = SnackBar(content: Text(response['message']));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
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
            Container(
              margin: EdgeInsets.only(top: 20.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StyledTitle('Mem_bers')
                ],
              )
            ),
            Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                height: double.infinity,
                child: FutureBuilder(
                  future: _getRoomMembers(),
                  builder: (context, projectSnap) {
                    if (projectSnap == null || projectSnap.data == null) {
                      return CircularProgressIndicator();
                    }
                    return ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        var user = projectSnap.data[index];
                        var gravatar = Gravatar(user['email']);
                        var url = gravatar.imageUrl(
                          size: 100,
                          defaultImage: GravatarImage.retro,
                          rating: GravatarRating.pg,
                          fileExtension: true,
                        );

                        var isOwner = user['id'] == widget.room['creator']['id'];
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
                      },
                    );
                  },
                ),
              )
            )
          ],
        )
      )
    );
  }
}
