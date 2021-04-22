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
  final amountLoss = ValueNotifier<double>(0);
  final amountGain = ValueNotifier<double>(0);
  final checkSum = ValueNotifier<double>(0);
  final balance = ValueNotifier<double>(0);
  final balanceColor = ValueNotifier<Color>(Colors.black);

  void clearSums() {
    amountLoss.value = 0;
    amountGain.value = 0;
    checkSum.value = 0;
    balance.value = 0;
    balanceColor.value = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(223, 223, 223, 100),
      child: SafeArea(
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
                    onPressed: () {
                      setState(() {
                        date = date.subtract(Duration(days: 30));
                        formattedDate = monthPickerDateFormat.format(date);
                        clearSums();
                      });
                    },
                    icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white, size: 40
                    ),
                    padding: EdgeInsets.all(0.0),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 180,
                    child: Text(
                      formattedDate.toString(),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        date = date.add(Duration(days: 30));
                        formattedDate = monthPickerDateFormat.format(date);
                        clearSums();
                      });
                    },
                    icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white, size: 40
                    ),
                    padding: EdgeInsets.all(0.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 38,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  //border: Border.all(color: Colors.indigo, width: 2),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: ValueListenableBuilder(
                              valueListenable: amountGain,
                              builder: (context, value, widget) {
                                return RichText(
                                  text: TextSpan(
                                    text: 'Gain: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: amountGain.value.toStringAsFixed(2),
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: ValueListenableBuilder(
                              valueListenable: amountLoss,
                              builder: (context, value, widget) {
                                return RichText(
                                  text: TextSpan(
                                    text: 'Loss: ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: amountLoss.value.toStringAsFixed(2),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Balance: ",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                        ValueListenableBuilder(
                          valueListenable: balance,
                          builder: (context, value, widget) {
                            return Text(
                              balance.value.toStringAsFixed(2),
                              style: TextStyle(
                                  color: balanceColor.value,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                        child: Text("Transaction history", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                      ),
                      Expanded(
                        child: transactionsListView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView transactionsListView() {
    var transactionsBox = Hive.box<Transaction>('transactions');
    List<Transaction> filteredList = List.empty(growable: true);

    for (int i = 0; i < transactionsBox.length; i++) {
      if (transactionsBox.getAt(i).date.year == date.year && transactionsBox.getAt(i).date.month == date.month) {
        filteredList.add(transactionsBox.getAt(i));
        this.checkSum.value += transactionsBox.getAt(i).amount;

        if (transactionsBox.getAt(i).type == TransactionType.income)
          this.amountGain.value += transactionsBox.getAt(i).amount;
        else
          this.amountLoss.value += transactionsBox.getAt(i).amount;
      }

      if (i == transactionsBox.length - 1) {
        this.balance.value = this.amountGain.value - this.amountLoss.value;

        if (balance.value > 0)
          balanceColor.value = Colors.green;
        else
          balanceColor.value = Colors.red;
      }
    }

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
          title: Text(transaction.amount.toString() ?? '',style: TextStyle(color: mainColor, fontSize: 18, fontWeight: FontWeight.bold),),
          subtitle: Text(transactionDateFormat.format(transaction.date).toString() + "\n" + (transaction.name ?? ''),),
        );
      },
    );
  }
}
