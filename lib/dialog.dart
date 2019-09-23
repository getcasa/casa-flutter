import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;

class Dialogs {
  final inputController = TextEditingController();

  void dispose() {
    inputController.dispose();
  }

  input(BuildContext context, String title, String placeholder, Function onSuccess) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(title, style: TextStyle(color: Colors.white),),
            content: SingleChildScrollView(
              child: TextField(
                controller: inputController,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  fillColor: Colors.white
                ),
                style: TextStyle(color: Colors.white),
              )
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () {
                  onSuccess(inputController.text);
                  Navigator.pop(context);
                },
                child: Text('Create'),
              )
            ],
          )
        );
      }
    );
  }
}
