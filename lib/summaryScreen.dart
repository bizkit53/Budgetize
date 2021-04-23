import 'package:budgetize/account.dart';
import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'transactionScreen.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(223, 223, 223, 100),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child:  Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        child: Text("Accounts", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                      Expanded(
                        child: accountsListView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child:  Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                          ),
                          child: Text("Last week expenses", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
                        Expanded(
                          child: Container(
                            transform: Matrix4.translationValues(-20, 10, 0),
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                borderData: FlBorderData(
                                  border: Border(bottom: BorderSide(width: 1), left: BorderSide(width: 1)),
                                ),
                                barGroups: [
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(y: 1),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 2,
                                    barRods: [
                                      BarChartRodData(y: 2),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 3,
                                    barRods: [
                                      BarChartRodData(y: 3),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 4,
                                    barRods: [
                                      BarChartRodData(y: 4),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 5,
                                    barRods: [
                                      BarChartRodData(y: 5),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 6,
                                    barRods: [
                                      BarChartRodData(y: 6),
                                    ],
                                  ),
                                  BarChartGroupData(
                                    x: 7,
                                    barRods: [
                                      BarChartRodData(y: 7),
                                    ],
                                  ),
                                ],
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
            ),
            Flexible(
              child:  Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        child: Text("Monthly balance changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              child: Row(
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
                          )),
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
                          Icon(Icons.add, size: 45)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ListView accountsListView() {
    var accountBox = Hive.box<Account>('accounts');

    return ListView.builder(
      itemExtent: 46,
      itemCount: accountBox.length + 1,
      itemBuilder: (context, index) {
        if(index < accountBox.length) {
          var account = accountBox.getAt(index) as Account;

          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(flex: 5, child: Text(account.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
                  Expanded(flex: 5, child: Text(account.cashAmount.toString())),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.edit, size: 28),
                      onPressed: () {
                        print("Edit account $index - button pressed");
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else {
          return Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(flex: 10, child: Text("Add account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
                  Expanded(flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.add_circle, size: 28,),
                      onPressed: () {
                        print("Add account - button pressed");
                      },
                    ),
                  ),
                ],
              ),
          );
        }
      },
    );
  }
}
