class Account {
  String name;
  Currencies currency;
  double cashAmount;

  Account(){
    name = "Wallet";
    currency = Currencies.USD;
    cashAmount = 0;
  }
}

enum Currencies {
  USD, EUR, PLN
}
