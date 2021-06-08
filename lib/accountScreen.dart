import 'package:budgetize/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class AccountScreen extends StatefulWidget {
  final bool editMode;
  final Account accountToEdit;

  const AccountScreen({Key key, this.editMode, this.accountToEdit})
      : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Color mainColor;
  String appBarTitle;
  String newAccountName;
  String secondButtonText;
  double iconSize = 32;
  double accountBalance;
  bool valuesInitialized = false;
  List<int> rowProportion = [1, 8, 2];

  bool addAccount() {
    this.newAccountName = this.newAccountName.trim();

    if (accountWithThisNameExists() == false){
      if(this.newAccountName != null && this.accountBalance != null){
        var accountBox = Hive.box<Account>('accounts');
        Account wallet = new Account(this.newAccountName, Currencies.USD, this.accountBalance);
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

  void editAccount() {
    throw Exception("not implemented yet");
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
    this.accountBalance = 0;
    this.valuesInitialized = true;

    if (widget.editMode == false) {
      this.appBarTitle = 'Add account';
      this.secondButtonText = 'Add';
    } else {
      this.appBarTitle = 'Edit account';
      this.secondButtonText = 'Edit';
      this.accountBalance = widget.accountToEdit.cashAmount;
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
                            maxLength: 20,
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
                            initialValue: this.accountBalance != null ? this.accountBalance.toString() : "",
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r"^\d{0,9}(\.\d{0,2})?")),
                            ],
                            onChanged: (value) {
                              this.accountBalance = double.tryParse(value);
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
                            editAccount();
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
