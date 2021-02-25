import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add income'),
          backgroundColor: Colors.green,
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
                  hintText: "(Optional) Transaction name",
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
            Flexible( // category
              flex: 5,
              fit: FlexFit.tight,
              child: TextField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(50.0),
                    borderSide: new BorderSide(),
                  ),
                  hintText: "Select category",
                ),
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
            Flexible(
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
                          side: BorderSide(color: Colors.green)),
                      color: Colors.green,
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
                          side: BorderSide(color: Colors.green)),
                      color: Colors.green,
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
