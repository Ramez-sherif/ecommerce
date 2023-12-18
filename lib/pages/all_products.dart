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
  Future getAllProducts({required String categoryId}) async {
    if (context.read<HomeProvider>().homeAllProducts.isEmpty) {
      await context.read<HomeProvider>().setHomeAllProducts(categoryId: categoryId);
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllProducts(categoryId: "0"),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AllProductsTopBarWidget(),
        const CategoriesList(),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 80),
            child: const ProductsGrid(),
          ),
        ),
      ],
    );
  }
}
