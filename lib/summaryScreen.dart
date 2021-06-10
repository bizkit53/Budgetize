import 'package:budgetize/account.dart';
import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'accountScreen.dart';
import 'transactionScreen.dart';
import 'package:pie_chart/pie_chart.dart' as _pieChart;

DateFormat formatter = DateFormat('dd-MM');
DateTime today = DateTime.now();

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  List<DateTime> days = [];
  List<DateTime> months = [];
  List<String> verbalMonth = [];
  List<String> daysFormatted = [];
  List<double> daySpendingAmount = [];
  List<String> daySpendingAmountCompactString = [];
  List<int> showTooltipIndicator = [];
  List<double> monthlySpendings = [];
  List<double> monthlyIncome = [];
  List<double> initialMonthlyBalanceOnAllAccounts = [];
  var transactionsBox = Hive.box<Transaction>('transactions');
  var accountsBox = Hive.box<Account>('accounts');
  static DateFormat monthVerbalDateFormat = new DateFormat.yMMMM();
  bool initialized = false;
  double maxSpendingValue;
  double allAccountsBalance;

  void initDays () {
    days = [];
    daysFormatted = [];
    daySpendingAmount = [];
    showTooltipIndicator = [];
    daySpendingAmountCompactString = [];
    monthlySpendings = [];
    monthlyIncome = [];
    months = [];
    verbalMonth = [];
    initialMonthlyBalanceOnAllAccounts = [];
    maxSpendingValue = 0;
    allAccountsBalance = 0;

    for(int i = 6; i >= 0; i--){
      var nextDay = today.subtract(Duration(days: i));
      var nextDayFormatted = formatter.format(nextDay);
      // jiffy is the date lib used for proper month subtraction
      DateTime jiffyDate = Jiffy().subtract(months: i).dateTime;
      var formattedDate = monthVerbalDateFormat.format(jiffyDate);

      days.add(nextDay);
      daysFormatted.add(nextDayFormatted);
      daySpendingAmount.insert(6-i, 0);
      showTooltipIndicator.insert(6-i, 0);
      daySpendingAmountCompactString.insert(6-i, "");
      monthlySpendings.insert(6-i, 0);
      monthlyIncome.insert(6-i, 0);
      months.insert(6-i, jiffyDate);
      verbalMonth.insert(6-i, formattedDate);
      initialMonthlyBalanceOnAllAccounts.insert(6-i, 0);
    }

    for(int i = 0; i < accountsBox.length; i++){
      allAccountsBalance += accountsBox.getAt(i).currentBalance;
    }
  }

  void calculateSpendings() {
    for (int i = 0; i < transactionsBox.length; i++) {
      var transaction = transactionsBox.getAt(i);

      for (int j = 6; j >= 0; j--) {
        var date = days.elementAt(j);

        if (transaction.type == TransactionType.expenditure &&
            transaction.date.year == date.year &&
            transaction.date.month == date.month &&
            transaction.date.day == date.day ) {

          daySpendingAmount[j] += transaction.amount;
        }

        if(transaction.date.month == months.elementAt(j).month && transaction.date.year == months.elementAt(j).year){
          if(transaction.type == TransactionType.expenditure)
            monthlySpendings[j] += transaction.amount;
          else
            monthlyIncome[j] += transaction.amount;
        }
      }
    }

    for (int j = 6; j >= 0; j--) {
      if (daySpendingAmount[j] > maxSpendingValue)
        maxSpendingValue = daySpendingAmount[j] * 1.25;

      if (daySpendingAmount[j] != 0)
        showTooltipIndicator[j] = 0;
      else
        showTooltipIndicator[j] = 1;

      daySpendingAmountCompactString[j] = NumberFormat.compact().format(daySpendingAmount[j]);

      if(j == 6) {
        initialMonthlyBalanceOnAllAccounts[j] = allAccountsBalance + monthlySpendings[j] - monthlyIncome[j];
      }
      else
        initialMonthlyBalanceOnAllAccounts[j] = initialMonthlyBalanceOnAllAccounts[j + 1] + monthlySpendings[j] - monthlyIncome[j];
    }
  }

  @override
  Widget build(BuildContext context) {
    if(initialized == false) {
      initDays();
      calculateSpendings();
      initialized = true;
    }

    return Container(
      color: Color.fromRGBO(223, 223, 223, 100),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 3,
              child:  Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8, bottom: 6),
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
            flex: 3,
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
                          child: Text("Weekly expenses", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        ),
                        Expanded(
                          child: Container(
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxSpendingValue,
                                barTouchData: BarTouchData(
                                  enabled: false,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: Colors.indigo,
                                    tooltipPadding: const EdgeInsets.only(bottom: -3),
                                    tooltipMargin: 0,
                                    getTooltipItem: (
                                        BarChartGroupData group,
                                        int groupIndex,
                                        BarChartRodData rod,
                                        int rodIndex,
                                        ) {
                                      return BarTooltipItem(
                                        daySpendingAmountCompactString[groupIndex],
                                        TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 12),
                                    getTitles: (double value) {
                                      return daysFormatted.elementAt(value.toInt());
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: false,
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: [
                                  BarChartGroupData(
                                    x: 0,
                                    barRods: [
                                      BarChartRodData(y: daySpendingAmount[0], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                                    ],
                                    showingTooltipIndicators: [showTooltipIndicator[0]],
                                  ),
                                  BarChartGroupData(
                                    x: 1,
                                    barRods: [
                                      BarChartRodData(y: daySpendingAmount[1], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                                    ],
                                    showingTooltipIndicators: [showTooltipIndicator[1]],
                                  ),
                                  BarChartGroupData(
                                    x: 2,
                                    barRods: [
                                      BarChartRodData(y: daySpendingAmount[2], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                                    ],
                                    showingTooltipIndicators: [showTooltipIndicator[2]],
                                  ),
                                  BarChartGroupData(
                                    x: 3,
                                    barRods: [
                                      BarChartRodData(y: daySpendingAmount[3], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                                    ],
                                    showingTooltipIndicators: [showTooltipIndicator[3]],
                                  ),
                                  BarChartGroupData(
                                    x: 4,
                                    barRods: [
                                      BarChartRodData(y: daySpendingAmount[4], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                                    ],
                                    showingTooltipIndicators: [showTooltipIndicator[4]],
                                  ),
                                  BarChartGroupData(
                                    x: 5,
                                    barRods: [
                                      BarChartRodData(y: daySpendingAmount[5], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                                    ],
                                    showingTooltipIndicators: [showTooltipIndicator[5]],
                                  ),
                                  BarChartGroupData(
                                    x: 6,
                                    barRods: [
                                      BarChartRodData(y: daySpendingAmount[6], colors: [Colors.lightBlueAccent, Colors.greenAccent])
                                    ],
                                    showingTooltipIndicators: [showTooltipIndicator[6]],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
            ),
            Flexible(
              flex: 3,
              child:  Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6, bottom: 7),
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
                      Expanded(
                        child: monthsSpendingListView(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: SizedBox(
                      child: FloatingActionButton(
                          heroTag: "addExpenditureButton",
                          elevation: 0,
                          onPressed: () {
                            print("Add expenditure button pressed.");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TransactionScreen(transactionType: TransactionType.expenditure, editMode: false, transactionToEdit: null,))).then((value) {
                                  setState(() {
                                    initialized = false;
                                  });
                                });
                          },
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.remove,
                            size: 50,
                          )),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: SizedBox(
                      child: FloatingActionButton(
                          heroTag: "addIncomeButton",
                          elevation: 0,
                          onPressed: () {
                            print("Add income button pressed.");
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TransactionScreen(transactionType: TransactionType.income, editMode: false, transactionToEdit: null,))).then((value) {
                                  setState(() {
                                    initialized = false;
                                  });
                                });
                          },
                          backgroundColor: Colors.green,
                          child: Icon(Icons.add, size: 45)),
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
      itemExtent: 51,
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
                  Expanded(flex: 5, child: Text(account.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)),
                  Expanded(flex: 5, child: Text(account.currentBalance.toString())),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _showPopupMenu(details.globalPosition, index, account);
                      },
                      child: Icon(Icons.more_vert, size: 28,),
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
                  Expanded(flex: 10, child: Text("Add account", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)),
                  Expanded(flex: 1,
                    child: GestureDetector(
                      child: Icon(Icons.add_circle, size: 28,),
                      onTapDown: (TapDownDetails details) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                AccountScreen(editMode: false, accountToEdit: null,))).then((value) {
                          setState(() {
                            print("Add account - button pressed");
                          });
                        });
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

  ListView monthsSpendingListView() {
    return ListView.builder(
      itemExtent: 155,
      itemCount: months.length - 1,
      itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(verbalMonth[6 - index], style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 4,
                        child: _pieChart.PieChart(
                          dataMap: <String, double> {
                            "Spendings" : monthlySpendings[6 - index],
                            "Income" : monthlyIncome[6 - index],
                          },
                          colorList: [
                            Colors.red,
                            Colors.green,
                          ],
                          chartType: _pieChart.ChartType.ring,
                          legendOptions: _pieChart.LegendOptions(showLegends: false),
                          chartValuesOptions: _pieChart.ChartValuesOptions(showChartValuesInPercentage: true),
                          ringStrokeWidth: 18,
                        )
                      ),
                      Expanded(flex: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Starting:"),
                                  Spacer(),
                                  Text(initialMonthlyBalanceOnAllAccounts[6 - index].toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Closing:"),
                                  Spacer(),
                                  Text((initialMonthlyBalanceOnAllAccounts[6 - index] + monthlyIncome[6 - index] - monthlySpendings[6 - index]).toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Change:"),
                                  Spacer(),
                                  Text((monthlyIncome[6 - index] - monthlySpendings[6 - index]).toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  void _showPopupMenu(Offset offset, int accountIndex, Account selectedAccount) async {
    double left = offset.dx;
    double top = offset.dy - 50;

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
                      AccountScreen(editMode: true, accountToEdit: selectedAccount,))).then((value) {
                setState(() {
                  print("Edit account - button pressed");
                  this.initialized = false;
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
                    print("Delete account - button pressed");
                    if(accountsBox.getAt(accountIndex).name == selectedAccount.name){
                      for(int i = 0; i < transactionsBox.length; i++){
                        if(transactionsBox.getAt(i).account.name == selectedAccount.name) {
                          transactionsBox.deleteAt(i);
                          i = -1;
                        }
                      }
                      accountsBox.deleteAt(accountIndex);
                      print("Account " + selectedAccount.name + " deleted.");
                      this.initialized = false;
                    }
                    Navigator.of(context).pop();
                  });
                },
              );

              AlertDialog alert = AlertDialog(
                title: Text("Delete"),
                content: Text("Are you sure you want to delete this account and all related transactions?"),
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
