import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;

class Dialogs {
  input(BuildContext context, String title, String description) {
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
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: description,
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  fillColor: Colors.white
                ),
                style: TextStyle(color: Colors.white),
              )
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => {
                  Navigator.pop(context)
                },
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => {
                  Navigator.pop(context)
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
