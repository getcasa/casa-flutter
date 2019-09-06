import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casa',
      theme: ThemeData(
        fontFamily: 'Manjari',
        primaryColor: Color.fromRGBO(255, 177, 66, 1),
        accentColor: Color.fromRGBO(255, 177, 66, 1),
      ),
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Text(
              'Welcome\nto',
              style: TextStyle(fontFamily: 'Manjari', fontSize: 50),
            )
          ),
          Text(
            'Casa',
            style: TextStyle(fontFamily: 'Manjari', fontSize: 50, color: Theme.of(context).accentColor),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
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
          FlatButton(
            onPressed: () {
              // Get call to API
            },
            child: Text(
              "Sign In",
            ),
          )
        ],
      ),
    );
  }
}
