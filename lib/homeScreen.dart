import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'placeholder_widget.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}
class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budgetize'),
      ),
      body: Center(
        child: _children.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed, // makes more than 3 items possible
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black.withOpacity(.60),
        onTap: (value) {
          setState(() => _currentIndex = value);
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
      ),
    );
  }
}