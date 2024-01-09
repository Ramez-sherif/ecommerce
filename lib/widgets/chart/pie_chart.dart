import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChart2 extends StatelessWidget {
  const PieChart2({Key? key, required this.allProducts,required this.title}) : super(key: key);
  final List<ProductModel> allProducts;
  final String title;
  @override
  Widget build(BuildContext context) {
    int length = 5;
    if(allProducts.length < 5){
      length = allProducts.length ;
    }
    allProducts.sort((a, b) => b.soldProducts.compareTo(a.soldProducts));
    Map<String, double> dataMap = {
      for (int i = 0; i<length;i++) allProducts[i].name: allProducts[i].quantity.toDouble(),
    };
    return Column(
      children: [
        Text(title),
        SizedBox(height: MediaQuery.of(context).size.height * 0.06),
        PieChart(
                dataMap: dataMap,
                 animationDuration: const Duration(milliseconds: 800),
                chartType: ChartType.disc, // You can use ChartType.ring for a ring chart
                chartRadius: MediaQuery.of(context).size.width / 2.0,
                colorList: const [
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.red,
                  Colors.purple,
                ],
                initialAngleInDegree: 0,
                chartLegendSpacing: 32,
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                ),
        ),
      ],
    );
  }
}



