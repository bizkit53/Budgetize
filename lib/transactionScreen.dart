import 'package:budgetize/main.dart';
import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'account.dart';
import 'category.dart';

DateFormat formatter = DateFormat('dd-MM-yyyy');
String formatted = formatter.format(DateTime.now());

class IncomeScreen extends StatefulWidget {
  final TransactionType transactionType;

  const IncomeScreen({Key key, this.transactionType }) : super(key: key);

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  Color mainColor;
  String appBarTitle;
  String transactionName;
  Account account = Hive.box<Account>('accounts').getAt(0);
  double transactionAmount;
  DateTime date = DateTime.now();
  Category selectedCategory;
  Category categoryType;
  List<CategoryWithIcon> categories;
  TransactionType type = TransactionType.income;

  bool isNull() {
    if (this.account == null ||
        this.transactionAmount == null ||
        this.date == null ||
        this.selectedCategory == null)
      return true;
    else
      return false;
  }

  void setTransactionType(){
    if (widget.transactionType == TransactionType.income) {
      this.mainColor = Colors.green;
      this.appBarTitle = "Add income";
      this.categories = incomeCategories;
      this.selectedCategory = incomeCategories.last;
    }
    else {
      this.mainColor = Colors.red;
      this.appBarTitle = "Add expense";
      this.categories = expenditureCategories;
      this.selectedCategory = expenditureCategories.last;
    }
  }

  void addTransaction() {
    if (isNull() == false) {
      var transactionBox = Hive.box<Transaction>('transactions');
      var transaction = new Transaction(
          this.transactionName,
          this.transactionAmount,
          this.account,
          this.date,
          this.selectedCategory,
          this.type);
      transactionBox.add(transaction);

      print(transaction.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    setTransactionType();
    return Theme(
      data: ThemeData(
        primarySwatch: mainColor,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(this.appBarTitle),
          backgroundColor: mainColor,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Flexible(
                // amount
                flex: 5,
                fit: FlexFit.tight,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  //maxLength: 18,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d?\d?")),
                  ],
                  onChanged: (value) {
                    this.transactionAmount = double.tryParse(value);
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.calculate,
                      color: mainColor,
                    ),
                    /*border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    borderSide: new BorderSide(),
                  ),*/
                    hintText: "Amount",
                  ),
                ),
              ),
              Flexible(
                // account
                flex: 5,
                fit: FlexFit.tight,
                child: DropdownButton(
                  hint: Text("Select account"),
                  value: account,
                  onChanged: (Account Value) {
                    setState(
                      () {
                        account = Value;
                      },
                    );
                  },
                  items: Hive.box<Account>('accounts')
                      .values
                      .toList()
                      .map((Account acc) {
                    return DropdownMenuItem<Account>(
                      value: acc,
                      child: Text(acc.name),
                    );
                  }).toList(),
                ),
              ),
              Flexible(
                  flex: 5,
                  //fit: FlexFit.tight,
                  child: TextButton.icon(
                    icon: Icon(Icons.calendar_today_rounded),
                    //shape: new RoundedRectangleBorder(
                    //    borderRadius: new BorderRadius.circular(30.0)),
                    label: Text(
                      formatted,
                      style: new TextStyle(
                        fontSize: 28,
                      ),
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme:
                                  ColorScheme.light(primary: mainColor),
                            ),
                            child: child,
                          );
                        },
                      ).then(
                        (date) {
                          setState(
                            () {
                              formatted = formatter.format(date);
                              this.date = date;
                            },
                          );
                        },
                      );
                    },
                  )),
              Flexible(
                // category
                flex: 5,
                fit: FlexFit.tight,
                child: DropdownButton(
                  //icon: Icon(Icons.calculate),
                  hint: Text("Select category"),
                  value: selectedCategory,
                  onChanged: (Category Value) {
                    setState(
                      () {
                        selectedCategory = Value;
                      },
                    );
                  },
                  items:
                      this.categories.map((CategoryWithIcon category) {
                    return DropdownMenuItem<CategoryWithIcon>(
                      value: category,
                      child: Row(
                        children: <Widget>[
                          category.icon,
                          SizedBox(
                            width: 45,
                          ),
                          Text(
                            category.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Flexible(
                // transaction name
                flex: 5,
                fit: FlexFit.tight,
                child: TextField(
                  onChanged: (String value) {
                    setState(
                          () {
                        this.transactionName = value;
                      },
                    );
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.description, color: mainColor,),
                    //border: new OutlineInputBorder(
                    //  borderRadius: new BorderRadius.circular(50.0),
                    //  borderSide: new BorderSide(),
                    //),
                    hintText: "Transaction name (optional)",
                  ),
                ),
              ),
              Flexible(
                // cancel and add buttons
                flex: 18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 47,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: mainColor)),
                        color: mainColor,
                        textColor: Colors.white,
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      height: 47,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: mainColor),
                        ),
                        color: mainColor,
                        textColor: Colors.white,
                        child: Text("Add"),
                        onPressed: () {
                          addTransaction();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
