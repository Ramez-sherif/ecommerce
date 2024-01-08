import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StockPieChart extends StatelessWidget {
  final List<ProductModel> allProducts;

  StockPieChart({required this.allProducts});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ProductStat, String>> series = [
      charts.Series(
        id: 'Stock',
        data: allProducts.map((product) {
          return ProductStat(
            product.name,
            0,
            product.quantity,
          );
        }).toList(),
        domainFn: (ProductStat stat, _) => stat.productName,
        measureFn: (ProductStat stat, _) => stat.quantityInStock,
        labelAccessorFn: (ProductStat stat, _) =>
            '${stat.productName}: ${stat.quantityInStock}', // Labels for each section
      ),
    ];

    return charts.PieChart(
      series,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
          arcWidth: 20, // Adjust the width of the pie segments
          arcRendererDecorators: [
            charts.ArcLabelDecorator()
          ] // Display labels inside pie segments
          ),
    );
  }
}

class ProductStat {
  final String productName;
  final int quantitySold;
  final int quantityInStock;

  ProductStat(this.productName, this.quantitySold, this.quantityInStock);
}
