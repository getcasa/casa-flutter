import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DeviceBox extends StatelessWidget {
  final Function tapAction;
  final Function longPressAction;
  final String text;
  final bool isClicked;
  final String status;
  final IconData icon;

  DeviceBox(this.text, String _icon, this.isClicked, this.status, this.tapAction, this.longPressAction) : this.icon = MdiIcons.fromString(_icon) != null ? MdiIcons.fromString(_icon) : MdiIcons.serverMinus;


  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: tapAction,
        onLongPress: longPressAction,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            children: <Widget>[
              Row(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      status,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isClicked ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
      elevation: 20.0,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
      color: isClicked ? Theme.of(context).accentColor : Colors.white,
    );
  }
}