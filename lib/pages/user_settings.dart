import 'package:casa/components/dialog.dart';
import 'package:casa/pages/home.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/store/store.dart';
import 'package:flutter/material.dart';
import 'package:casa/request.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  Request request = new Request();
  Dialogs dialogs = new Dialogs();
  CasaStore store = CasaStore();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    firstnameController.text = store.user.firstname;
    lastnameController.text = store.user.lastname;
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
              MdiIcons.logoutVariant,
              color: Colors.red,
            ),
            onPressed: () {
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
              child: StyledTitle('Pro_fil')
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: firstnameController,
                    decoration: InputDecoration(
                      hintText: 'Firstname',
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
              margin: EdgeInsets.only(top: 20.0),
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                  child: TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                      hintText: 'Lastname',
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
                          response = await request.updateUser(store.user.id, {
                            'firstname': firstnameController.text,
                            'lastname': lastnameController.text
                          });
                        } catch (e) {
                          final snackBar = SnackBar(content: Text(e));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                          return;
                        }
                        store.updateProfil(firstnameController.text, lastnameController.text);
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
              child: StyledTitle('Sec_urity')
            ),
          ],
        )
      )
    );
  }
}
