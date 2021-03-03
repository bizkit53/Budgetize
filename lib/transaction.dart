import 'package:budgetize/account.dart';
import 'package:budgetize/category.dart';
import 'package:intl/intl.dart';

enum TransactionType {income, expenditure}

class Transaction {
  String name;
  Account account;
  double amount;
  DateTime date;
  Category category;
  TransactionType type;

  Transaction(String name, double amount, Account account, DateTime date, Category category, TransactionType type) {
    this.name = name;
    this.amount = amount;
    this.account = account;
    this.date = date;
    this.category = category;
    this.type = type;
  }

  bool isNull(){
    if(this.amount == null || this.account == null || this.date == null || this.category == null)
      return true;
    else
      return false;
  }
}

