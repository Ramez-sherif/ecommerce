import 'package:ecommerce/models/chart_data.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChart extends StatelessWidget {
  const BarChart({Key? key, required this.allProducts, required this.title})
      : super(key: key);
  final List<ProductModel> allProducts;
  final String title;
  
  @override
  Widget build(BuildContext context) {
      int length = 5;
    if (allProducts.length < 5) {
      length = allProducts.length;
    }
     allProducts.sort((a, b) => b.soldProducts.compareTo(a.soldProducts));
    List<ProductModel> trending = [];
    for(int i = 0;i< length;i++){
      trending.add(allProducts[i]);
    }
    List<charts.Series<ProductStat, String>> series = [
      charts.Series(
        id: 'Sold',
        data: trending.map((product) {
          return ProductStat(
            product.name,
            product.soldProducts,
            0,
          );
        }).toList(),
        domainFn: (ProductStat stat, _) => stat.productName,
        measureFn: (ProductStat stat, _) => stat.quantitySold,
        measureLowerBoundFn: (ProductStat stat, _) => 0,
        colorFn: (ProductStat stat, _) =>
            charts.ColorUtil.fromDartColor(Colors.blue),
        displayName: 'Sold', // Label for sold products
      ),
      charts.Series(
        id: 'Stock',
        data: trending.map((product) {
          return ProductStat(
            product.name,
            0,
            product.quantity,
          );
        }).toList(),
        domainFn: (ProductStat stat, _) => stat.productName,
        measureFn: (ProductStat stat, _) => stat.quantityInStock,
        colorFn: (ProductStat stat, _) =>
            charts.ColorUtil.fromDartColor(Colors.green),
        displayName: 'Stock', // Label for stock products
      ),
    ];

    return Column(
      children: [
        Text(title),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: charts.BarChart(
            series,
            animate: true,
            barGroupingType: charts.BarGroupingType.grouped,
            vertical: true,
            domainAxis: const charts.OrdinalAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                labelAnchor: charts.TickLabelAnchor.centered,
                labelJustification: charts.TickLabelJustification.inside,
              ),
            ),
            behaviors: [
              charts.SeriesLegend(
                position:
                    charts.BehaviorPosition.bottom, // Position of the legend
                desiredMaxRows: 2, // Adjust rows in the legend if needed
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductStat {
  final String productName;
  final int quantitySold;
  final int quantityInStock;

  ProductStat(this.productName, this.quantitySold, this.quantityInStock);
}
