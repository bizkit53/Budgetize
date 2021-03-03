import 'package:budgetize/transaction.dart';

import 'account.dart';
import 'category.dart';

class Expenditure extends Transaction {
  Expenditure(String name, double amount, Account account, DateTime date, Category category) : super(name, amount, account, date, category, TransactionType.expenditure);
}