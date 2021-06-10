import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject with EquatableMixin {
  @HiveField(0)
  String name;
  @HiveField(1)
  Currencies currency;
  @HiveField(2)
  double currentBalance;
  @HiveField(3)
  double initialBalance;

  Account(String name, Currencies currency, double initialBalance){
    this.name = toBeginningOfSentenceCase(name);
    this.currency = currency;
    this.currentBalance = initialBalance;
    this.initialBalance = initialBalance;
  }

  @override
  String toString() {
    return this.name;
  }

  @override
  List<Object> get props {
    return [name, currency, currentBalance, initialBalance];
  }
}


@HiveType(typeId: 1)
enum Currencies {
  @HiveField(0)
  USD,
  @HiveField(1)
  EUR,
  @HiveField(2)
  PLN,
}
