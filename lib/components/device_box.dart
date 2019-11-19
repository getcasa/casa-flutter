import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeviceBox extends StatelessWidget {
  Function action;
  String text;
  bool isClicked;
  IconData icon;

  DeviceBox(String _text, String _icon, bool _isClicked, Function _action) {
    action = _action;
    text = _text;
    isClicked = _isClicked;
    icon = MdiIcons.fromString(_icon) != null ? MdiIcons.fromString(_icon) : MdiIcons.serverMinus;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FlatButton(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        onPressed: action,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isClicked ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Icon(
              icon,
              color: isClicked ? Colors.white : Colors.black,
            )
          ]
        ),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
      ),
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
      elevation: 20.0,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
      color: isClicked ? Theme.of(context).accentColor : Colors.white,
    );
  }
}