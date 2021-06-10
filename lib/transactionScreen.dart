import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'account.dart';
import 'category.dart';
import 'package:fluttertoast/fluttertoast.dart';

DateFormat formatter = DateFormat('dd-MM-yyyy');
String formatted = formatter.format(DateTime.now());

class TransactionScreen extends StatefulWidget {
  final TransactionType transactionType;
  final bool editMode;
  final Transaction transactionToEdit;

  const TransactionScreen({Key key, this.transactionType, this.editMode, this.transactionToEdit }) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  Color mainColor;
  String appBarTitle;
  String transactionName;
  String secondButtonText;
  Account account = Hive.box<Account>('accounts').getAt(0);
  Account initialAccountOfEditedTransaction;
  double initialAmountOfEditedTransaction;
  double transactionAmount;
  double iconSize = 32;
  DateTime date;
  Category selectedCategory;
  Category categoryType;
  List<CategoryWithIcon> categories;
  List<int> rowProportion = [1, 8, 2];
  TransactionType transactionType;
  bool valuesInitialized = false;
  bool editModeInitialized = false;


  bool isNull() {
    if (this.account == null ||
        this.transactionAmount == null ||
        this.date == null ||
        this.selectedCategory == null ||
        this.transactionType == null)
      return true;
    else
      return false;
  }

  void setTransactionType(){
    if (widget.transactionType == TransactionType.income) {
      this.mainColor = Colors.green;
      this.appBarTitle = "Add income";
      this.categories = incomeCategories;
      this.selectedCategory = incomeCategories.first;
    }
    else {
      this.mainColor = Colors.red;
      this.appBarTitle = "Add expense";
      this.categories = expenditureCategories;
      this.selectedCategory = expenditureCategories.first;
    }
    this.transactionType = widget.transactionType;
    this.date = DateTime.now();
    formatted = formatter.format(date);
    this.valuesInitialized = true;
    this.secondButtonText = "Add";
  }

  bool addTransaction() {
    if (isNull() == false) {
      var transactionBox = Hive.box<Transaction>('transactions');

      if(transactionType == TransactionType.expenditure)
        this.account.currentBalance -= this.transactionAmount;
      else
        this.account.currentBalance += this.transactionAmount;

      this.account.save();

      var transaction = new Transaction(
          this.transactionName,
          this.transactionAmount,
          this.account,
          this.date,
          this.selectedCategory,
          this.transactionType);
      transactionBox.add(transaction);

      updateAccountBalanceInAppropriateTransactions(this.account);
      return true;
    }
    else
      return false;
  }

  void updateAccountBalanceInAppropriateTransactions(Account updatedAccount){
    var transactionsBox = Hive.box<Transaction>('transactions');

    for(int i = 0; i < transactionsBox.length; i++){
      if(transactionsBox.getAt(i).account.name == updatedAccount.name) {
        transactionsBox.getAt(i).account = updatedAccount;
        transactionsBox.getAt(i).save();
      }
    }
  }

  void editModeDataSetter(){
    this.editModeInitialized = true;
    this.secondButtonText = "Edit";
    this.transactionAmount = widget.transactionToEdit.amount;
    this.transactionName = widget.transactionToEdit.name;
    this.transactionType = widget.transactionType;
    this.date = widget.transactionToEdit.date;
    this.initialAmountOfEditedTransaction = widget.transactionToEdit.amount;
    formatted = formatter.format(date);

    for (int i = 0; i < Hive.box<Account>('accounts').length; i++){
      var tempAccount = Hive.box<Account>('accounts').getAt(i);
      if (identical(widget.transactionToEdit.account, tempAccount)) {
        this.account = tempAccount;
        this.initialAccountOfEditedTransaction = tempAccount;
      }
    }

    for (int i = 0; i < categories.length; i++){
      if(categories.elementAt(i) == widget.transactionToEdit.category)
        this.selectedCategory = categories.elementAt(i);
    }
  }

  bool editTransaction() {
    if (isNull() == false) {
      widget.transactionToEdit.account = this.account;
      widget.transactionToEdit.category = this.selectedCategory;
      widget.transactionToEdit.date = this.date;
      widget.transactionToEdit.name = this.transactionName;

      if(widget.transactionToEdit.type == TransactionType.expenditure) {
        this.initialAccountOfEditedTransaction.currentBalance += widget.transactionToEdit.amount;
        widget.transactionToEdit.account.currentBalance -= this.transactionAmount;
      }
      else{
        this.initialAccountOfEditedTransaction.currentBalance -= widget.transactionToEdit.amount;
        widget.transactionToEdit.account.currentBalance += this.transactionAmount;
      }

      widget.transactionToEdit.amount = this.transactionAmount;
      this.initialAccountOfEditedTransaction.save();
      widget.transactionToEdit.account.save();

      if(widget.transactionToEdit.account.name == this.initialAccountOfEditedTransaction)
        updateAccountBalanceInAppropriateTransactions(widget.transactionToEdit.account);
      else{
        updateAccountBalanceInAppropriateTransactions(widget.transactionToEdit.account);
        updateAccountBalanceInAppropriateTransactions(this.initialAccountOfEditedTransaction);
      }

      return true;
    }
    else
      return false;
  }

  void showToastFieldsOmmitted(){
    Fluttertoast.showToast(
        msg: "Some required fields have been omitted.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    if(valuesInitialized == false)
      setTransactionType();
    if(widget.editMode == true && editModeInitialized == false)
      editModeDataSetter();

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
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 14,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: rowProportion[0],
                            child: Icon(Icons.calculate, color: mainColor, size: iconSize,),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            // amount
                            flex: rowProportion[1],
                            child: TextFormField(
                              autofocus: true,
                              initialValue: this.transactionAmount != null ? this.transactionAmount.toString() : "",
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r"^\d{0,7}(\.\d{0,2})?")),
                              ],
                              onChanged: (value) {
                                this.transactionAmount = double.tryParse(value);
                              },
                              decoration: InputDecoration(
                                hintText: "Amount",
                              ),
                            ),
                          ),
                          Expanded(
                            flex: rowProportion[2],
                            child: Container(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: rowProportion[0],
                            child: Icon(Icons.account_box_rounded, color: mainColor, size: iconSize,),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            // account
                            flex: rowProportion[1],
                            child: DropdownButton(
                              underline: Container(height: 1, color: Colors.grey,),
                              hint: Text("Select account"),
                              iconSize: 0,
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
                          Expanded(
                            flex: rowProportion[2],
                            child: Container(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: rowProportion[0],
                            child: Icon(Icons.calendar_today_rounded, color: mainColor, size: iconSize,),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            flex: rowProportion[1],
                            child: TextButton(
                              child: Text(
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
                            ),
                          ),
                          Expanded(
                            flex: rowProportion[2],
                            child: Container(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: rowProportion[0],
                            child: Icon(Icons.category_rounded, color: mainColor, size: iconSize,),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            // category
                            flex: rowProportion[1],
                            child: DropdownButton(
                              underline: Container(height: 1, color: Colors.grey,),
                              isExpanded: true,
                              hint: Text("Select category"),
                              iconSize: 0,
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
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        category.name,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      category.icon,
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            flex: rowProportion[2],
                            child: Container(),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: rowProportion[0],
                            child: Icon(Icons.description, color: mainColor, size: iconSize,),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Expanded(
                            // transaction name
                            flex: rowProportion[1],
                            child: TextFormField(
                              initialValue: this.transactionName != null ? this.transactionName.toString() : "",
                              onChanged: (String value) {
                                setState(
                                      () {
                                    this.transactionName = value;
                                  },
                                );
                              },
                              maxLength: 20,
                              decoration: InputDecoration(
                                hintText: "Transaction name (optional)",
                                counterText: "",
                              ),
                            ),
                          ),
                          Expanded(
                            flex: rowProportion[2],
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  // cancel and add/edit buttons
                  flex: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 52,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: mainColor)),
                          color: mainColor,
                          textColor: Colors.white,
                          child: Text("Cancel", style: TextStyle(fontSize: 20),),
                          onPressed: () {
                            this.valuesInitialized = false;
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 170,
                        height: 52,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: mainColor),
                          ),
                          color: mainColor,
                          textColor: Colors.white,
                          child: Text(secondButtonText, style: TextStyle(fontSize: 20),),
                          onPressed: () {
                            if(widget.editMode == false) {
                              if (addTransaction()) {
                                this.valuesInitialized = false;
                                Navigator.of(context).pop();
                              }
                              else {
                                showToastFieldsOmmitted();
                              }
                            }
                            else {
                              if(editTransaction()){
                                Navigator.of(context).pop();
                              }
                              else {
                                showToastFieldsOmmitted();
                              }
                            }
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
      ),
    );
  }
}
