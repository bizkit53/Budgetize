import 'package:budgetize/category.dart';
import 'package:budgetize/transaction.dart';
import 'package:budgetize/transactionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'account.dart';

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

  void updateAccountBalanceInApropriateTransactionsAfterTransactionRemoval(Account updatedAccount){
    var transactionsBox = Hive.box<Transaction>('transactions');

    for(int i = 0; i < transactionsBox.length; i++){
      if(transactionsBox.getAt(i).account.name == updatedAccount.name) {
        transactionsBox.getAt(i).account = updatedAccount;
        transactionsBox.getAt(i).save();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    clearSums();
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
                        var jiffy = Jiffy(date).subtract(months: 1);
                        date = new DateTime(jiffy.year, jiffy.month);
                        formattedDate = monthPickerDateFormat.format(date);
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
                        var jiffy = Jiffy(date).add(months: 1);
                        date = new DateTime(jiffy.year, jiffy.month);
                        formattedDate = monthPickerDateFormat.format(date);
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
                                        text: NumberFormat('#,###,##0.0#').format(amountGain.value).replaceAll(",", " "),
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
                                        text: NumberFormat('#,###,##0.0#').format(amountLoss.value).replaceAll(",", " "),
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
                        ValueListenableBuilder(
                          valueListenable: balance,
                          builder: (context, value, widget) {
                            return RichText(
                              text: TextSpan(
                                text: "Balance: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: NumberFormat('#,###,##0.0#').format(balance.value).replaceAll(",", " "),
                                    style: TextStyle(color: balanceColor.value),
                                  ),
                                ],
                              ),
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

    filteredList.sort((a, b) => a.date.compareTo(b.date));

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var transaction = filteredList.elementAt(index) as Transaction;
        var mainColor;
        var categoryIcon;
        String sign;

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

        if (transaction.type == TransactionType.income)
          sign = "+";
        else
          sign = "-";

        return ListTile(
          leading: categoryIcon,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(transactionDateFormat.format(transaction.date).toString() +"\n" + transaction.account.name, style: TextStyle(fontSize: 14),),
              Text(sign + " " + NumberFormat('#,###,##0.0#').format(transaction.amount).replaceAll(",", " "),style: TextStyle(color: mainColor, fontSize: 15, fontWeight: FontWeight.bold),),
            ],
          ),
          subtitle: Text((transaction.name ?? ""),),
          trailing: GestureDetector(
            onTapDown: (TapDownDetails details) {
              _showPopupMenu(details.globalPosition, index, filteredList);
            },
            child: Icon(Icons.more_vert, size: 22,),
          ),
        );
      },
    );
  }

  void _showPopupMenu(Offset offset, int transactionIndex, List<Transaction> filteredList) async {
    double left = offset.dx;
    double top = offset.dy - 50;
    Transaction selectedTransaction = filteredList.elementAt(transactionIndex);
    var transactionsBox = Hive.box<Transaction>('transactions');

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
          child: TextButton(child: Text('Edit', style: TextStyle(color: Colors.black),),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      TransactionScreen(
                        transactionType: selectedTransaction.type, editMode: true, transactionToEdit: selectedTransaction,))).then((value) {
                setState(() {
                });
              });
            },
          ),
        ),
        PopupMenuItem<String>(
            child: TextButton(child: Text('Delete', style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();

                  Widget cancelButton = TextButton(
                    child: Text("Cancel"),
                    onPressed:  () {
                      Navigator.of(context).pop();
                    },
                  );

                  Widget deleteButton = TextButton(
                    child: Text("Delete"),
                    onPressed:  () {
                      setState(() {
                        bool deleted = false;
                        for(int i = 0; i < transactionsBox.length && deleted == false; i++)
                          if(transactionsBox.getAt(i) == selectedTransaction) {
                            var accountBox = Hive.box<Account>('accounts');
                            bool accountFound = false;

                            for (int j = 0; j < accountBox.length && accountFound == false; j++) {
                              if(selectedTransaction.account == accountBox.getAt(j)) {
                                accountFound = true;

                                if(selectedTransaction.type == TransactionType.expenditure) {
                                  accountBox.getAt(j).cashAmount += selectedTransaction.amount;
                                  selectedTransaction.account = accountBox.getAt(j);
                                }
                                else {
                                  accountBox.getAt(j).cashAmount -= selectedTransaction.amount;
                                  selectedTransaction.account = accountBox.getAt(j);
                                }
                                accountBox.getAt(j).save();
                                updateAccountBalanceInApropriateTransactionsAfterTransactionRemoval(accountBox.getAt(j));
                                transactionsBox.deleteAt(i);
                                print("Transaction deleted.");
                                deleted = true;
                              }
                            }
                          }
                        Navigator.of(context).pop();
                      });
                    },
                  );

                  AlertDialog alert = AlertDialog(
                    title: Text("Delete"),
                    content: Text("Are you sure you want to delete this item?"),
                    actions: [
                      cancelButton,
                      deleteButton,
                    ],
                  );

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
              },
            ),
        ),
      ],
    );
  }
}
