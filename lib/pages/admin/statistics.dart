import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/category.dart';
import 'package:ecommerce/services/product.dart';
import 'package:ecommerce/widgets/chart/chart_bar.dart';
import 'package:ecommerce/widgets/chart/pie_chart.dart';
import 'package:flutter/material.dart';

class AdminStatisticsPage extends StatefulWidget {
  const AdminStatisticsPage({super.key});

  // Your widget implementation
  @override
  State<AdminStatisticsPage> createState() => _AdminStatisticsPageState();
}

class _AdminStatisticsPageState extends State<AdminStatisticsPage> {
  Map<String, dynamic> statistics = {"Product": 12};

  // @override
  // void initState() {
  //   super.initState();
  //   // Fetch and calculate statistics when the widget initializes
  //   fetchAndCalculateStatistics();
  // }

  // Future<void> fetchAndCalculateStatistics() async {
  //   Map<String, dynamic> calculatedStatistics =
  //       await calculateProductStatistics();
  //   setState(() {
  //     statistics = calculatedStatistics;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List<ProductModel> allProducts = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: 
          SingleChildScrollView(
            child: FutureBuilder<List<ProductModel>>(
                future: ProductService.getAllProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    
                    return  Center(child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No Data Available'));
                  }
                  allProducts= snapshot.data!;
                  CategoryModel mostSoldCategory = CategoryService.getMostSoldCategory(allProducts);
                  
                  return Column(
                    children: [
                      const Text(""),
                      //   child: ListView.builder(
                      //       itemCount: snapshot.data!.length,
                      //       itemBuilder: (context, index) {
                      //         return Column(
                      //           children: [
                      //             // Display statistics using Text widgets, charts, or any other visualization methods
                      //             // Example:
                      //             ListTile(
                      //               title: Text(
                      //                   'Product Name: ${snapshot.data![index].name}'),
                      //             ),
                      //             ListTile(
                      //               title: Text(
                      //                   'Total Products Sold: ${snapshot.data![index].soldProducts}'),
                      //             ),
                      //             ListTile(
                      //               title: Text(
                      //                   'Total Products Left: ${snapshot.data![index].quantity}'),
                      //             ),
                                 
                      //             // Add more ListTile widgets for other statistics
                      //           ],
                      //           // You can add more configurations or widgets here for each list item
                      //         );
                      //       }),
                      // ),
                     SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width ,
                          child: 
                              Column(
                                
                                children: [
                                  PieChart2(allProducts:allProducts,title:"Trending Products Stock"),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                  BarChart(allProducts: allProducts,
                             title: "Trending Products Stock Vs Sold"),
                              SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                             Container(
                               height: MediaQuery.of(context).size.height * 0.03,
                               width: MediaQuery.of(context).size.width * 0.5,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child:  Center(child: Text("Most sold category: ${mostSoldCategory.name}",style: TextStyle(color: Theme.of(context).colorScheme.primary),)),
                             )
                                ],
                              ),
                           
                          ),
                    ],
                  );
                }),
          ),
    );
  }
}
