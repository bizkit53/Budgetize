import 'package:budgetize/summaryScreen.dart';
import 'package:budgetize/transactionHistoryScreen.dart';
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
    SummaryScreen(),
    TransactionHistoryScreen(),
    PlaceholderWidget(Colors.green)
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Budgetize'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
              icon: Icon(Icons.schedule), title: Text('Transakcje')),
        ],
      ),
    );
  }
}
