import 'package:budgetize/account.dart';
import 'package:budgetize/category.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'transaction.g.dart';

DateFormat formatter = DateFormat('dd-MM-yyyy');

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expenditure
}

@HiveType(typeId: 3)
class Transaction extends HiveObject with EquatableMixin {
  @HiveField(0)
  String name;
  @HiveField(1)
  Account account;
  @HiveField(2)
  double amount;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  Category category;
  @HiveField(5)
  TransactionType type;

  Transaction(String name, double amount, Account account, DateTime date,
      Category category, TransactionType type) {
    this.name = name;
    this.amount = amount;
    this.account = account;
    this.date = date;
    this.category = category;
    this.type = type;
  }

  @override
  String toString() {
    String output = "Transaction name: ${this.name}\n" +
        "Transaction type: ${this.type}\n" +
        "Account: ${this.account.toString()}\n" +
        "Date: ${formatter.format(this.date)}\n" +
        "Category: ${this.category.toString()}\n" +
        "Ammount: ${this.amount}\n";
    return output;
  }

  @override
  List<Object> get props {
    return [name, account, amount, date, category, type];
  }
}
