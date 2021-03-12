import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  Currencies currency;
  @HiveField(2)
  double cashAmount;

  Account(String name, Currencies currency){
    this.name = name;
    this.currency = currency;
    this.cashAmount = 0;
  }

  @override
  String toString() {
    return this.name;
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
