import 'package:flutter/material.dart';

class Category{
  String name;
  Icon icon;

  Category(this.name, this.icon);
}

class IncomeCategory extends Category{
  IncomeCategory(String name, Icon icon) : super(name, icon);
}

class ExpenditureCategory extends Category{
  ExpenditureCategory(String name, Icon icon) : super(name, icon);
}

List<IncomeCategory> incomeCategories = <IncomeCategory>[
  IncomeCategory('Salary',Icon(Icons.monetization_on,color:  const Color(0xFF167F67),)),
  IncomeCategory('Investment profit',Icon(Icons.account_balance,color:  const Color(0xFF167F67),)),
  IncomeCategory('Benefits',Icon(Icons.spa,color:  const Color(0xFF167F67),)),
  IncomeCategory('Loan payback',Icon(Icons.credit_card,color:  const Color(0xFF167F67),)),
  IncomeCategory('Gift',Icon(Icons.card_giftcard,color:  const Color(0xFF167F67),)),
  IncomeCategory('Others',Icon(Icons.mood,color:  const Color(0xFF167F67),)),
];

List<ExpenditureCategory> expenditureCategories = <ExpenditureCategory>[

];