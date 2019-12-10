import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:casa/components/modal_icon.dart';

class SelectIcon extends StatelessWidget {
  final Function updateIcon;
  final String selectedIcon;

  SelectIcon(this.updateIcon, this.selectedIcon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 20.0),
          child: Material(
            child: FlatButton(
              padding: EdgeInsets.all(10),
              onPressed: () {
                ModalIcon(this.updateIcon, this.selectedIcon).showIconsList(context);
              },
              child: Icon(
                MdiIcons.fromString(selectedIcon),
                size: 80,
              ),
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
            ),
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
            elevation: 20.0,
            shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          alignment: Alignment.center,
          child: Text(
            'Choose icon...',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54
            )
          )
        ),
      ],
    );
  }
}