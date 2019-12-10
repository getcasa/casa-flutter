import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ModalIcon {
  final Function updateIcon;
  final String selectedIcon;

  ModalIcon(this.updateIcon, this.selectedIcon);

  var icons = MdiIcons.getIconsName();

  changeIconList(String value) {
    icons = MdiIcons.getIconsName().where((elem) => elem.contains(value)).toList();
  }

  showIconsList(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Find an icon...'
                ),
                onChanged: (String value) {
                  changeIconList(value);
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: GridView.builder(
                padding: EdgeInsets.all(20.0),
                shrinkWrap: true,
                itemCount: icons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0
                ),
                itemBuilder: (BuildContext context, int index) {
                  var icon = MdiIcons.fromString(icons[index]);
                  var isSelected = icons[index] == selectedIcon;

                  return Material(
                    child: FlatButton(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      onPressed: () {
                        updateIcon(icons[index]);
                        Navigator.pop(context);
                      },
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
                    elevation: 20.0,
                    shadowColor: Color.fromRGBO(0, 0, 0, 0.4),
                    color: isSelected ? Theme.of(context).accentColor : Colors.white,
                  );
                },
              )
            )
          ]
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0)
        )
      ),
    );
  }
}