import 'package:casa/pages/signup.dart';
import 'package:casa/pages/splash_screen.dart';
import 'package:casa/request.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a custom Form widget.
class SignInPage extends StatefulWidget {
  @override

  _SignInPageState createState() => _SignInPageState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _SignInPageState extends State<SignInPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Request request = new Request();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        padding: EdgeInsets.only(
          top: 50.0,
          left: 20.0,
          right: 20.0,
          bottom: 20.0
        ),
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Welcome\nto',
              style: TextStyle(fontSize: 50),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 30.0),
            child: Text(
              'Casa',
              style: TextStyle(fontSize: 50, color: Theme.of(context).accentColor),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
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
            margin: EdgeInsets.only(bottom: 20.0),
            child: Material(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Container(
                  child: Text(
                    "You don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  child: Material(
                    child: FlatButton(
                      onPressed: () async {
                        var response;
                        try {
                          response = await request.signin(emailController.text, passwordController.text);
                        } catch (e) {
                          final snackBar = SnackBar(content: Text(e));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                          return;
                        }

                        await request.prefs.setString('token', response['message']);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SplashScreen()),
                        );
                      },
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                    ),
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                    elevation: 20.0,
                    shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
