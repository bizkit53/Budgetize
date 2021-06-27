import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 4)
class Category extends HiveObject{
  @HiveField(0)
  String name;

  Category(this.name);

  @override
  String toString() {
    return this.name;
  }
}

class CategoryWithIcon extends Category{
  Icon icon;
  CategoryWithIcon(String name, this.icon) : super(name);
}

class IncomeCategoryWithIcon extends CategoryWithIcon{
  IncomeCategoryWithIcon(String name, Icon icon) : super(name, icon);
}

class ExpenditureCategoryWithIcon extends CategoryWithIcon{
  ExpenditureCategoryWithIcon(String name, Icon icon) : super(name, icon);
}

List<IncomeCategoryWithIcon> incomeCategories = <IncomeCategoryWithIcon>[
  IncomeCategoryWithIcon('Salary',Icon(Icons.monetization_on,color:  const Color(0xFF167F67),)),
  IncomeCategoryWithIcon('Gift',Icon(Icons.card_giftcard,color:  const Color(0xFF167F67),)),
  IncomeCategoryWithIcon('Benefit',Icon(Icons.spa,color:  const Color(0xFF167F67),)),
  IncomeCategoryWithIcon('Rental fee',Icon(Icons.home_work_outlined,color:  const Color(0xFF167F67),)),
  IncomeCategoryWithIcon('Investment',Icon(Icons.account_balance,color:  const Color(0xFF167F67),)),
  IncomeCategoryWithIcon('Stock market',Icon(Icons.business_center_sharp,color:  const Color(0xFF167F67),)),
  IncomeCategoryWithIcon('Loan payback',Icon(Icons.credit_card,color:  const Color(0xFF167F67),)),
  IncomeCategoryWithIcon('Compensation',Icon(Icons.clean_hands_rounded,color:  const Color(0xFF167F67),)),
  IncomeCategoryWithIcon('Other incomes',Icon(Icons.mood,color:  const Color(0xFF167F67),)),
];

List<ExpenditureCategoryWithIcon> expenditureCategories = <ExpenditureCategoryWithIcon>[
  ExpenditureCategoryWithIcon('Shopping',Icon(Icons.shopping_basket,color:  const Color(0xFF7F1667),)),
  ExpenditureCategoryWithIcon('Food',Icon(Icons.local_restaurant,color:  const Color(0xFF7F1667),)),
  ExpenditureCategoryWithIcon('Transport',Icon(Icons.emoji_transportation,color:  const Color(0xFF7F1667),)),
  ExpenditureCategoryWithIcon('Entertainment',Icon(Icons.attractions,color:  const Color(0xFF7F1667),)),
  ExpenditureCategoryWithIcon('Health and relaxation',Icon(Icons.medical_services,color:  const Color(0xFF7F1667),)),
  ExpenditureCategoryWithIcon('Family',Icon(Icons.family_restroom,color:  const Color(0xFF7F1667),)),
  ExpenditureCategoryWithIcon('Sport',Icon(Icons.fitness_center,color:  const Color(0xFF7F1667),)),
  ExpenditureCategoryWithIcon('Bills',Icon(Icons.monetization_on,color:  const Color(0xFF7F1667),)),
  ExpenditureCategoryWithIcon('Other expenses',Icon(Icons.mood,color:  const Color(0xFF7F1667),)),
];