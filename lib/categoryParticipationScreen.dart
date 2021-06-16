import 'package:budgetize/category.dart';
import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'account.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'categoryChart.dart';
import 'categoryPieChartSlice.dart';

class CategoryParticipationScreen extends StatefulWidget {
  @override
  _CategoryParticipationScreenState createState() => _CategoryParticipationScreenState();
}

class _CategoryParticipationScreenState extends State<CategoryParticipationScreen> {
  static DateTime date = DateTime.now();
  static DateFormat monthPickerDateFormat = new DateFormat.yMMMM();
  var formattedDate = monthPickerDateFormat.format(date);
  bool initializedAccounts = false;
  bool initializedViewingMode = false;
  bool valuesByExpenses = true;
  List<Account> accounts = [];
  List<double> valuesOfAllIncomeTransactionsByCategory;
  List<double> valuesOfAllExpenditureTransactionsByCategory;
  List<Color> categoryColorsOnChart = [Colors.blue, Colors.red, Colors.purple[300], Colors.yellow, Colors.green[900], Colors.green[400], Colors.orange, Colors.indigo, Colors.teal[300], Colors.limeAccent];
  List<CategoryPieChartSlice> pieChartData;
  Account account;

  void initAccountList(){
    accounts.clear();
    account = Account('All accounts ', Currencies.USD, 0);
    accounts.add(account);
    for(int i = 0; i < Hive.box<Account>('accounts').length; i++)
      accounts.add(Hive.box<Account>('accounts').getAt(i));

    this.initializedAccounts = true;
  }

  void getValuesByCategories(){
    var transactionsBox = Hive.box<Transaction>('transactions');
    valuesOfAllIncomeTransactionsByCategory = List<double>.filled(incomeCategories.length, 0.0);
    valuesOfAllExpenditureTransactionsByCategory = List<double>.filled(expenditureCategories.length, 0.0);

    for (int i = 0; i < transactionsBox.length; i++) {
      bool valueAssigned = false;

      if (this.account == this.accounts.elementAt(0)) {
        if (transactionsBox.getAt(i).date.year == date.year && transactionsBox.getAt(i).date.month == date.month) {
          if (transactionsBox.getAt(i).type == TransactionType.income)
            for (int j = 0; j < incomeCategories.length && valueAssigned == false; j++) {
              if (transactionsBox.getAt(i).category.name == incomeCategories.elementAt(j).name) {
                valuesOfAllIncomeTransactionsByCategory[j] += transactionsBox.getAt(i).amount;
                valueAssigned = true;
              }
            }
          else
            for (int j = 0; j < expenditureCategories.length && valueAssigned == false; j++) {
              if (transactionsBox.getAt(i).category.name == expenditureCategories.elementAt(j).name) {
                valuesOfAllExpenditureTransactionsByCategory[j] += transactionsBox.getAt(i).amount;
                valueAssigned = true;
              }
            }
        }
      }
      else {
        if (transactionsBox.getAt(i).account.name == this.account.name && transactionsBox.getAt(i).date.year == date.year && transactionsBox.getAt(i).date.month == date.month) {
          if (transactionsBox.getAt(i).type == TransactionType.income)
            for (int j = 0; j < incomeCategories.length && valueAssigned == false; j++) {
              if (transactionsBox.getAt(i).category.name == incomeCategories.elementAt(j).name) {
                valuesOfAllIncomeTransactionsByCategory[j] += transactionsBox.getAt(i).amount;
                valueAssigned = true;
              }
            }
          else
            for (int j = 0; j < expenditureCategories.length && valueAssigned == false; j++) {
              if (transactionsBox.getAt(i).category.name == expenditureCategories.elementAt(j).name) {
                valuesOfAllExpenditureTransactionsByCategory[j] += transactionsBox.getAt(i).amount;
                valueAssigned = true;
              }
            }
        }
      }
    }

    if (this.valuesByExpenses) {
      getChartExpenseData();
    }
    else {
      getChartIncomeData();
    }

    pieChartData.sort((a, b) => b.sumValue.compareTo(a.sumValue));
  }

  void switchMode(){
    this.initializedViewingMode = true;

    if (this.valuesByExpenses) {
      this.valuesByExpenses = false;
      getChartIncomeData();
    }
    else {
      this.valuesByExpenses = true;
      getChartExpenseData();
    }
  }

  void getChartIncomeData() {
    this.pieChartData = List<CategoryPieChartSlice>.empty(growable: true);

    for (int i = 0; i < incomeCategories.length; i++)
      if(valuesOfAllIncomeTransactionsByCategory[i] != 0)
        this.pieChartData.add(new CategoryPieChartSlice(incomeCategories[i].name, valuesOfAllIncomeTransactionsByCategory[i], charts.ColorUtil.fromDartColor(categoryColorsOnChart[i])));
  }

  void getChartExpenseData() {
    this.pieChartData = List<CategoryPieChartSlice>.empty(growable: true);

    for (int i = 0; i < expenditureCategories.length; i++)
      if(valuesOfAllExpenditureTransactionsByCategory[i] != 0)
        this.pieChartData.add(new CategoryPieChartSlice(expenditureCategories[i].name, valuesOfAllExpenditureTransactionsByCategory[i], charts.ColorUtil.fromDartColor(categoryColorsOnChart[i])));
  }

  @override
  Widget build(BuildContext context) {
    if (this.initializedAccounts == false) {
      initAccountList();
    }
    getValuesByCategories();

    return Container(
      color: Color.fromRGBO(223, 223, 223, 100),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo,
                border: Border.all(
                  width: 0,
                  color: Colors.indigo,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: account,
                          onChanged: (Account value) {
                            setState(
                                  () {
                                account = value;
                              },
                            );
                          },
                          dropdownColor: Colors.indigo,
                          iconEnabledColor: Colors.white,
                          items: this.accounts.map((Account acc) {
                            return DropdownMenuItem<Account>(
                              value: acc,
                              child: Text(acc.name, style: TextStyle(color: Colors.white),),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo,
                border: Border.all(
                  width: 0,
                  color: Colors.indigo,
                ),
              ),
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
            //Container(
            //child: pieChartDataMap,
            //),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                          child: Stack(
                            children: [
                              CategoryChart(pieChartData),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    print("Chart type changed.");
                                    switchMode();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: categoryListView(),
                      )
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

  ListView categoryListView() {
    var data = this.pieChartData;
    int nonZeroItems = 0;

    for (int i = 0; i < data.length; i++)
      if (data[i].sumValue != 0)
        nonZeroItems++;

    if (nonZeroItems == 0)
      return ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return ListTile(
              title: Center(child: Text("No transaction found")),
            );
          }
      );

    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          if (data[index].sumValue == 0)
            return SizedBox(height: 0, width: 0,);
          else
            return ListTile(
              leading: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: charts.ColorUtil.toDartColor(data[index].color),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(data[index].categoryName),
                  Text(NumberFormat.currency(name: "").format(data[index].sumValue).replaceAll(",", " ")),
                ],
              ),
            );
        }
    );
  }
}