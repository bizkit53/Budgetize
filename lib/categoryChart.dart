import 'package:flutter/cupertino.dart';
import 'categoryPieChartSlice.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CategoryChart extends StatelessWidget {
  final List<CategoryPieChartSlice> data;
  double sumOfAllValues = 0;

  CategoryChart(this.data);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < data.length; i++)
      this.sumOfAllValues += data[i].sumValue;

    List<charts.Series<CategoryPieChartSlice, String>> dataSeries = [
      charts.Series(
        id: "Categories",
        data: this.data,
        domainFn: (CategoryPieChartSlice series, _) => series.categoryName,
        measureFn: (CategoryPieChartSlice series, _) => series.sumValue,
        colorFn: (CategoryPieChartSlice series, _) => series.color,
        labelAccessorFn: (CategoryPieChartSlice series, _) => (series.sumValue/this.sumOfAllValues * 100).toStringAsFixed(0) + "%",
      )
    ];

    if (this.data.isNotEmpty)
      return charts.PieChart(
        dataSeries,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
                labelPosition: charts.ArcLabelPosition.outside),
          ],
          arcWidth: 25,
        ),
      );
    else
      return Container(width: 0, height: 0,);
  }
}