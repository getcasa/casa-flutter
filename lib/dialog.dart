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

  select(BuildContext context, String title, List<dynamic> selections, int selected, Function onClick) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: selections.length,
          itemBuilder: (BuildContext ctxt, int index) {
            Widget leading = Padding(
              padding: EdgeInsets.all(0)
            );
            if (selected == index) {
              leading = Icon(Icons.check);
            }
            return ListTile(
              leading: leading,
              title: Text(selections[index]),
              onTap: () {
                onClick(index);
                Navigator.pop(context);
              },
            );
          }
        );
      }
    );
  }

  confirm(BuildContext context, String title, Function onSuccess) {
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
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              FlatButton(
                onPressed: () {
                  onSuccess();
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              )
            ],
          )
        );
      }
    );
  }

  options(BuildContext context, String title, List<dynamic> options, Function onSuccess) {
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
            content: Column(
              children: options.map((option) {
                var checkbox = CheckboxListTile(
                  title: Text(option['name']),
                  value: option['value'],
                  onChanged: (bool value) {
                    var i = options.indexWhere((_option) => _option['name'] == option['name']);
                    options[i]['value'] = value;
                  },
                );
                return checkbox;
              }).toList()
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              FlatButton(
                onPressed: () {
                  onSuccess(options);
                  Navigator.pop(context);
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
              )
            ],
          )
        );
      }
    );
  }
}
