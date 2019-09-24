import 'package:casa/home.dart';
import 'package:casa/rooms.dart';
import 'package:flutter/material.dart';

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
            Icons.home,
            color: Color.fromARGB(255, 0, 0, 0)
          ),
          title: new Text('Home')
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.apps,
            color: Color.fromARGB(255, 0, 0, 0)
          ),
          title: new Text('Rooms')
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.schedule,
            color: Color.fromARGB(255, 0, 0, 0)
          ),
          title: new Text('Automations')
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
          default:
            return;
        }
      },
    );
  }
}