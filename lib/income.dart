import 'package:budgetize/category.dart';
import 'package:budgetize/transaction.dart';

import 'account.dart';

class Income extends Transaction {
  Income(String name, double amount, Account account, DateTime date, Category category) : super(name, amount, account, date, category, TransactionType.income);
}