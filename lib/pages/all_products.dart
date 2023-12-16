import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/widgets/all_products/categories_list.dart';
import 'package:ecommerce/widgets/all_products/products_grid.dart';
import 'package:ecommerce/widgets/all_products/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  Future getAllProducts() async {
    if (context.read<HomeProvider>().homeAllProducts.isEmpty) {
      await context.read<HomeProvider>().setHomeAllProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return buildBody();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildBody() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AllProductsTopBarWidget(),
        CategoriesList(),
        SizedBox(height: 10),
        ProductsGrid(),
      ],
    );
  }
}
