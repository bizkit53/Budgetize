import 'package:budgetize/account.dart';
import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class AccountScreen extends StatefulWidget {
  final bool editMode;
  final Account accountToEdit;

  const AccountScreen({Key key, this.editMode, this.accountToEdit}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Color mainColor;
  String appBarTitle;
  String newAccountName;
  String secondButtonText;
  double iconSize = 32;
  double initialAccountBalance;
  bool valuesInitialized = false;
  List<int> rowProportion = [1, 8, 2];

  bool addAccount() {
    if(this.newAccountName != null)
      this.newAccountName = this.newAccountName.trim();

    if (accountWithThisNameExists() == false){
      if(this.newAccountName != null && this.initialAccountBalance != null){
        var accountBox = Hive.box<Account>('accounts');
        Account wallet = new Account(this.newAccountName, Currencies.USD, this.initialAccountBalance);
        accountBox.add(wallet);
        return true;
      }
      else{
       showToastFieldsOmmitted();
       return false;
      }
    }
    else{
      showToastAccountAlreadyExists();
      return false;
    }
  }

  bool editAccount() {
    Account oldAccount = new Account(widget.accountToEdit.name, widget.accountToEdit.currency, widget.accountToEdit.initialBalance);
    oldAccount.currentBalance = widget.accountToEdit.currentBalance;

    if(this.newAccountName.toLowerCase() == widget.accountToEdit.name.toLowerCase()){
      if(this.initialAccountBalance != null) {
        widget.accountToEdit.initialBalance = this.initialAccountBalance;
        widget.accountToEdit.currentBalance = oldAccount.currentBalance - oldAccount.initialBalance + this.initialAccountBalance;
        widget.accountToEdit.save();
        updateAccountDetailsInAppropriateTransactions(oldAccount, widget.accountToEdit);
        return true;
      }
      else{
        showToastFieldsOmmitted();
        return false;
      }
    }
    else{
      if(accountWithThisNameExists() == false) {
        if(this.newAccountName != null && this.initialAccountBalance != null){
          widget.accountToEdit.name = this.newAccountName;
          widget.accountToEdit.initialBalance = this.initialAccountBalance;
          widget.accountToEdit.currentBalance = oldAccount.currentBalance - oldAccount.initialBalance + this.initialAccountBalance;
          widget.accountToEdit.save();
          updateAccountDetailsInAppropriateTransactions(oldAccount, widget.accountToEdit);
          return true;
        }
        else{
          showToastFieldsOmmitted();
          return false;
        }
      }
      else{
        showToastAccountAlreadyExists();
        return false;
      }
    }
  }

  void updateAccountDetailsInAppropriateTransactions(Account currentAccount, Account updatedAccount){
    var transactionsBox = Hive.box<Transaction>('transactions');

    for(int i = 0; i < transactionsBox.length; i++){
      if(transactionsBox.getAt(i).account.name.toLowerCase() == currentAccount.name.toLowerCase()) {
        transactionsBox.getAt(i).account.name = updatedAccount.name;
        transactionsBox.getAt(i).account.initialBalance = updatedAccount.initialBalance;
        transactionsBox.getAt(i).account.currentBalance = updatedAccount.currentBalance;
        transactionsBox.getAt(i).account.currency = updatedAccount.currency;
      }
      transactionsBox.getAt(i).save();
    }
  }

  bool accountWithThisNameExists() {
    if(this.newAccountName == null)
      return false;

    for (int i = 0; i < Hive.box<Account>('accounts').length; i++){
      var tempAccount = Hive.box<Account>('accounts').getAt(i);
      if (this.newAccountName.toLowerCase() == tempAccount.name.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  void showToastAccountAlreadyExists(){
    Fluttertoast.showToast(
        msg: "Account with that name already exists.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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

  bool setMode() {
    this.mainColor = Theme.of(context).primaryColor;
    this.initialAccountBalance = 0;
    this.valuesInitialized = true;

    if (widget.editMode == false) {
      this.appBarTitle = 'Add account';
      this.secondButtonText = 'Add';
    } else {
      this.appBarTitle = 'Edit account';
      this.secondButtonText = 'Edit';
      this.initialAccountBalance = widget.accountToEdit.initialBalance;
      this.newAccountName = widget.accountToEdit.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(this.valuesInitialized == false)
      setMode();

    return Scaffold(
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
            children: [
              Flexible(
                flex: 14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: rowProportion[0],
                          child: Icon(Icons.account_circle_rounded, color: mainColor, size: iconSize,),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Expanded(
                          // amount
                          flex: rowProportion[1],
                          child: TextFormField(
                            autofocus: true,
                            initialValue: widget.accountToEdit != null ? widget.accountToEdit.name : "",
                            onChanged: (String value) {
                              setState(
                                    () {
                                  this.newAccountName = value;
                                },
                              );
                            },
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: "Account name",
                              hintText: "Enter account name",
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
                            initialValue: this.initialAccountBalance != null ? this.initialAccountBalance.toString() : "",
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r"^\-?\d{0,9}(\.\d{0,2})?")),
                            ],
                            onChanged: (value) {
                              this.initialAccountBalance = double.tryParse(value);
                            },
                            decoration: InputDecoration(
                              labelText: "Initial account balance",
                              hintText: "Enter initial balance",
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
                          if(widget.editMode == false){
                            if(addAccount()){
                              Navigator.of(context).pop();
                            }
                          }
                          else{
                            if(editAccount()){
                              Navigator.of(context).pop();
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
    );
  }
}
