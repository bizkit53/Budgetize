import 'package:budgetize/account.dart';

class Transaction {
  String name;
  double amount;
  Account account;
  DateTime date;

  Transaction() {
    this.name = "";
    this.amount = 0;
    this.account = Account();
    this.date = DateTime.now();
  }

  Transaction.specified(String name, double amount, Account account, DateTime date) {
    this.name = name;
    this.amount = amount;
    this.account = account;
    this.date = date;
  }
}