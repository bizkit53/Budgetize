import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed, // makes more than 3 items possible
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black.withOpacity(.60),
      onTap: (value) {
        setState(() => _currentIndex = value);
        print("Navigation bar pressed. Current index is $_currentIndex.");
      },
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.pie_chart),
          title: new Text('Podsumowanie'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.bar_chart),
          title: new Text('Analiza'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            title: Text('Transakcje')
        ),
      ],
    );
  }
}
