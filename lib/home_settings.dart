import 'package:casa/dialog.dart';
import 'package:casa/styled_components.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
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
  List<dynamic> home;
  final homeNameController = TextEditingController();
  final homeAddressController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[],
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
              child: StyledTitle('Mem_bers')
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
                      itemCount: projectSnap.data['data'].length,
                      itemBuilder: (context, index) {
                        var user = projectSnap.data['data'][index];
                        var gravatar = Gravatar(user['email']);
                        var url = gravatar.imageUrl(
                          size: 100,
                          defaultImage: GravatarImage.retro,
                          rating: GravatarRating.pg,
                          fileExtension: true,
                        );

                        return ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(url),
                          ),
                          title: Text(
                            user['firstname'] + ' ' + user['lastname'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: PopupMenuButton(
                            onSelected: (select) {
                              switch (select) {
                                case 'edit':
                                  break;
                                case 'delete':
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
                          ),
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
