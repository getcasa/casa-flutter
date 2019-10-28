import 'package:casa/components/dialog.dart';
import 'package:casa/components/styled_components.dart';
import 'package:casa/pages/splash_screen.dart';
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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmationController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    firstnameController.text = store.user.firstname;
    lastnameController.text = store.user.lastname;
    emailController.text = store.user.email;
  }

  @override
  Widget build(BuildContext context) {
    var gravatar = Gravatar(store.user.email);
    var url = gravatar.imageUrl(
      size: 200,
      defaultImage: GravatarImage.retro,
      rating: GravatarRating.pg,
      fileExtension: true,
    );

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
              dialogs.confirm(context, "You really want to sign out?", () async {
                try {
                  await request.signout();
                } catch (e) {
                  final snackBar = SnackBar(content: Text(e));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  return;
                }
                store.user = null;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(url),
            ),
          ),
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
                        response = await request.updateUserProfil(store.user.id, {
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
            child: StyledTitle('Ema_il')
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Material(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
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
                        response = await request.updateUserEmail(store.user.id, {
                          'email': emailController.text
                        });
                      } catch (e) {
                        final snackBar = SnackBar(content: Text(e));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        return;
                      }
                      store.user.email = emailController.text;
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
            child: StyledTitle('Pas_sword')
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Material(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'New password',
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
                  controller: newPasswordConfirmationController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'New password confirmation',
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
                        response = await request.updateUserPassword(store.user.id, {
                          'password': passwordController.text,
                          'newPassword': newPasswordController.text,
                          'newPasswordConfirmation': newPasswordConfirmationController.text
                        });
                      } catch (e) {
                        final snackBar = SnackBar(content: Text(e));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        return;
                      }
                      final snackBar = SnackBar(content: Text(response['message']));
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                      passwordController.text = "";
                      newPasswordController.text = "";
                      newPasswordConfirmationController.text = "";
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
        ],
      )
    );
  }
}
