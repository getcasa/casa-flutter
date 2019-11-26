import 'package:casa/components/dialog.dart';
import 'package:casa/pages/home.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/store/store.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

class HomeSettingsPage extends StatefulWidget {
  @override
  _HomeSettingsPageState createState() => _HomeSettingsPageState();

  final dynamic home;
  const HomeSettingsPage({Key key, this.home}): super(key: key);
}

class _HomeSettingsPageState extends State<HomeSettingsPage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  CasaStore store = CasaStore();
  final homeNameController = TextEditingController();
  final homeAddressController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> permissionsOptions = [];

  @override
  void initState() {
    super.initState();
    homeNameController.text = widget.home['name'];
    homeAddressController.text = widget.home['address'];
    request.init().then((_token) {
      return;
    });
  }

  Future<dynamic> _getHomeMembers() async {
    var response = await request.getHomeMembers(widget.home['id']);
    return response;
  }

  Future<dynamic> _addHomeMember(String email) {
    return request.addHomeMember(widget.home['id'], { 'email': email }).then((data) {
      final snackBar = SnackBar(content: Text(data['message']));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }, onError: (err) {
      final snackBar = SnackBar(content: Text(err));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  Future<Null> _removeHomeMember(String userId) async {
    var response;
    try {
      response = await request.removeHomeMember(widget.home['id'], userId);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    setState(() {});
    final snackBar = SnackBar(content: Text(response['message']));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<Null> _deleteHome() async {
    try {
      await request.deleteHome(widget.home['id']);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(homeId: '',)),
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
                            response = await request.editHomeMember(
                              widget.home['id'],
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
              dialogs.confirm(context, "You really want to delete " + widget.home['name'] + " and all datas?", () async {
                await _deleteHome();
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
                    controller: homeNameController,
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
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: homeAddressController,
                    decoration: InputDecoration(
                      hintText: 'Address',
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
                          response = await request.editHome(widget.home['id'], {
                            'name': homeNameController.text,
                            'address': homeAddressController.text
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
                  StyledTitle('Mem_bers'),
                  Container(
                    width: 30,
                    height: 30,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                      padding: EdgeInsets.all(0),
                      child: Icon(Icons.add),
                      onPressed: () {
                        dialogs.input(context, 'Add a member', 'Email', _addHomeMember);
                      },
                    )
                  )
                ],
              )
            ),
            Flexible(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 20.0),
                height: double.infinity,
                child: FutureBuilder(
                  future: _getHomeMembers(),
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

                        var isOwner = user['id'] == widget.home['creator']['id'];
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
                            trailing: !isOwner && !isMe ? PopupMenuButton(
                              onSelected: (select) {
                                switch (select) {
                                  case 'edit':
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
                                    break;
                                  case 'remove':
                                    dialogs.confirm(context, "You really want to remove " + user['firstname'] + " from your home?", () async {
                                      await _removeHomeMember(user['id']);
                                    });
                                    break;
                                  default:
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem(
                                    value: 'remove',
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                        color: Colors.red
                                      ),
                                    ),
                                  )
                                ];
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
