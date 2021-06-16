import 'package:charts_flutter/flutter.dart' as charts;

class CategoryPieChartSlice {
  final String categoryName;
  final double sumValue;
  final charts.Color color;

  CategoryPieChartSlice(this.categoryName, this.sumValue, this.color);
}
