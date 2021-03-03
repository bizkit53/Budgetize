import 'package:budgetize/bottomNavigationBar.dart';
import 'package:budgetize/incomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'placeholder_widget.dart';
import 'incomeScreen.dart';

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
        centerTitle: true,
        title: Text('Budgetize'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: SizedBox(
                    child: FloatingActionButton(
                        heroTag: "removeButton",
                        elevation: 0,
                        onPressed: () {
                          print("Remove button pressed.");
                        },
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.remove,
                          size: 45,
                        )), // not implemented yet
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    child: FloatingActionButton(
                        heroTag: "addButton",
                        elevation: 0,
                        onPressed: () {
                          print("Add button pressed.");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IncomeScreen()));
                        },
                        backgroundColor: Colors.green,
                        child:
                            Icon(Icons.add, size: 45)), // not implemented yet
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(),
    );
  }
}
