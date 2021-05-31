import 'package:flutter/material.dart';
import '../utils/theme.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      backgroundColor: PrimaryColor,
      selectedItemColor: SecondaryColorLight,
      unselectedItemColor: TextColor,
      onTap: (index) {
        () => {};
      },
      items: [
        BottomNavigationBarItem(icon: new Icon(Icons.timer), label: 'Horas'),
        BottomNavigationBarItem(
            icon: new Icon(Icons.adjust_outlined), label: 'Check-in'),
        BottomNavigationBarItem(
            icon: new Icon(Icons.person_add), label: 'Tap-in')
      ],
    );
  }
}
