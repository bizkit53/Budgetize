import 'package:budgetize/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'category.dart';

DateFormat formatter = DateFormat('dd-MM-yyyy');
String formatted = formatter.format(DateTime.now());

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  IncomeCategory selectedCategory;
  Color mainColor = Colors.green;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add income'),
          backgroundColor: mainColor,
        ),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(   // transaction name
              flex: 5,
              fit: FlexFit.tight,
              child: TextField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    borderSide: new BorderSide(),
                  ),
                  hintText: "Transaction name (optional)",
                ),
              ),
            ),
            Flexible( // account
              flex: 5,
              fit: FlexFit.tight,
              child: TextField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    borderSide: new BorderSide(),
                  ),
                  hintText: "Select account",
                ),
              ),
            ),
            Flexible( // date //TODO wielkosc okna wyboru daty
                              //TODO kolor okna wyboru daty
              flex: 5,
              //fit: FlexFit.tight,
              child: FlatButton(
                color: mainColor,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: Text(formatted,
                  style: new TextStyle(
                    fontSize: 28,
                  ),),
                onPressed: () {
                    showDatePicker(context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100)
                    ).then((date) {
                      setState(() {
                        formatted = formatter.format(date);
                      });
                    });
                },
              )
            ),
            Flexible( // category
              flex: 5,
              fit: FlexFit.tight,
              child: DropdownButton(
                hint:  Text("Select category"),
                value: selectedCategory,
                onChanged: (IncomeCategory Value) {
                  setState(() {
                    selectedCategory = Value;
                  });
                },
                items: incomeCategories.map((IncomeCategory category) {
                  return  DropdownMenuItem<IncomeCategory>(
                    value: category,
                    child: Row(
                      children: <Widget>[
                        category.icon,
                        SizedBox(width: 45,),
                        Text(
                          category.name,
                          style:  TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Flexible( // amount
              flex: 5,
              fit: FlexFit.tight,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    borderSide: new BorderSide(),
                  ),
                  hintText: "Amount of transaction",
                ),
              ),
            ),
            Flexible( // cancel and add buttons
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
                          side: BorderSide(color: mainColor)),
                      color: mainColor,
                      textColor: Colors.white,
                      child: Text("Add"),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}

