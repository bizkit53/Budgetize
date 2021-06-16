import 'package:budgetize/categoryParticipationScreen.dart';
import 'package:budgetize/summaryScreen.dart';
import 'package:budgetize/transactionHistoryScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    CategoryParticipationScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 0,
        title: Text('Budgetize', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: GestureDetector(
          child: _children[_currentIndex],
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity > 0) {
              setState(() => _currentIndex = (_currentIndex - 1) % 3);
            } else if(details.primaryVelocity < 0){
              setState(() => _currentIndex = (_currentIndex + 1) % 3);
            }
          }),
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
            title: new Text('Summary'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), title: Text('Transactions')),
          BottomNavigationBarItem(
            icon: new Icon(Icons.category_outlined),
            title: new Text('Categories'),
          ),
        ],
      ),
    );
  }
}
