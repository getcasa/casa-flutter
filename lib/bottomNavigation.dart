import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
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
        print(index);
      },
    );
  }
}