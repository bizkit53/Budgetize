import 'package:budgetize/account.dart';
import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
                        child: Text("Accounts", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
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
              ),
            )
          ],
        ),
      ),
    );
  }

  ListView accountsListView() {
    var accountBox = Hive.box<Account>('accounts');

    return ListView.separated(
      itemCount: accountBox.length,
      itemBuilder: (context, index) {
        var account = accountBox.getAt(index) as Account;

        return ListTile(
          //leading: Icon(Icons.card_giftcard_outlined),
          title: Text(account.name.toString() ?? '',style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
          subtitle: Text(account.cashAmount.toString(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print ("Tile button pressed");
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(thickness: 3,);
      },
    );
  }
}
