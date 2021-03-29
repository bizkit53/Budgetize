import 'dart:io';
import 'package:budgetize/account.dart';
import 'package:budgetize/category.dart';
import 'package:budgetize/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory document = await getApplicationDocumentsDirectory();
  await Hive.registerAdapter(CurrenciesAdapter());
  await Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.init(document.path);
  final transactionsBox = await Hive.openBox<Transaction>('transactions');
  final accountBox = await Hive.openBox<Account>('accounts');

  if (accountBox.length == 0) { // default wallet
    Account wallet = new Account("wallet", Currencies.USD);
    accountBox.add(wallet);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budgetize',
      theme: ThemeData(
        appBarTheme: AppBarTheme(elevation: 0.0),
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
    ),
     home: Home(),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}