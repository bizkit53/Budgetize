import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'transactionScreen.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TransactionScreen(transactionType: TransactionType.expenditure,)));
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
                            builder: (context) => TransactionScreen(transactionType: TransactionType.income,)));
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
    );
  }
}
