import 'package:budgetize/category.dart';
import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  static DateTime date = DateTime.now();
  static DateFormat monthPickerDateFormat = new DateFormat.yMMMM();
  static DateFormat transactionDateFormat = new DateFormat.MEd();
  var formattedDate = monthPickerDateFormat.format(date);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            height: 45,
            width: double.infinity,
            color: Colors.indigo,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: (){
                    setState(() {
                      date = date.subtract(Duration(days: 30));
                      formattedDate = monthPickerDateFormat.format(date);
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 40),
                  padding: EdgeInsets.all(0.0),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 180,
                  child: Text(formattedDate.toString(), style: TextStyle(fontSize: 18, color: Colors.white),),
                ),
                IconButton(
                  onPressed: (){
                    setState(() {
                      date = date.add(Duration(days: 30));
                      formattedDate = monthPickerDateFormat.format(date);
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 40),
                  padding: EdgeInsets.all(0.0),
                ),
              ],
            ),
          ),
          Expanded(
            child: transactionsListView(),
          ),
        ],
      ),
    );
  }

  ListView transactionsListView() {
    var transactionsBox = Hive.box<Transaction>('transactions');
    List<Transaction> filteredList = List.empty(growable: true);
    
    for(int i = 0; i < transactionsBox.length; i++)
      if (transactionsBox.getAt(i).date.year == date.year && transactionsBox.getAt(i).date.month == date.month)
        filteredList.add(transactionsBox.getAt(i));
      
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var transaction = filteredList.elementAt(index) as Transaction;
        var mainColor;
        var categoryIcon;

        if (transaction.type == TransactionType.income) {
          mainColor = Colors.green;
          for (int i = 0; i < incomeCategories.length; i++)
            if (transaction.category.name == incomeCategories.elementAt(i).name) {
              categoryIcon = incomeCategories.elementAt(i).icon;
              break;
            }
        } else {
          mainColor = Colors.red;
          for (int i = 0; i < expenditureCategories.length; i++)
            if (transaction.category.name == expenditureCategories.elementAt(i).name) {
              categoryIcon = expenditureCategories.elementAt(i).icon;
              break;
            }
        }

        return ListTile(
          leading: categoryIcon,
          title: Text(transaction.amount.toString() ?? '', style: TextStyle(color: mainColor, fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Text(transactionDateFormat.format(transaction.date).toString() + "\n" + (transaction.name ?? '')),
        );
      },
    );
  }
}
