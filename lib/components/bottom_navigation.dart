import 'package:casa/pages/select_automations.dart';
import 'package:casa/pages/home.dart';
import 'package:casa/pages/rooms.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BottomNavigation extends StatelessWidget {
  int navigationIndex;
  String homeId;

  BottomNavigation(int index, String id) {
    navigationIndex = index;
    homeId = id;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 20.0,
      currentIndex: navigationIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            MdiIcons.homeOutline,
            color: Color.fromARGB(255, 0, 0, 0)
          ),
          title: Text(
            'Home',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          )
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.apps,
            color: Color.fromARGB(255, 0, 0, 0)
          ),
          title: Text(
            'Rooms',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          )
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.schedule,
            color: Color.fromARGB(255, 0, 0, 0)
          ),
          title: Text(
            'Automations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          )
        )
      ],
      onTap: (index) {
        if (index == navigationIndex) return;

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(homeId: homeId)),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RoomsPage(homeId: homeId)),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SelectAutomationsPage(homeId: homeId)),
            );
            break;
          default:
            return;
        }
      },
    );
  }
}