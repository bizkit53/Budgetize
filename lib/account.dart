import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject with EquatableMixin {
  @HiveField(0)
  String name;
  @HiveField(1)
  Currencies currency;
  @HiveField(2)
  double cashAmount;

  Account(String name, Currencies currency, double initialBalance){
    this.name = name;
    this.currency = currency;
    this.cashAmount = initialBalance;
  }

  @override
  String toString() {
    return this.name;
  }

  @override
  List<Object> get props {
    return [name, currency, cashAmount];
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
