// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names
import 'package:ecommerce/providers/products.dart';
import 'package:ecommerce/services/product.dart';
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

class _AllProductsPageState extends State<AllProductsPage>
    with WidgetsBindingObserver {
  late final ProductsProvider productsProvider;

  @override
  void initState() {
    super.initState();
    productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
  }

  Future getAllProducts() async {
    if (productsProvider.homeAllProducts.isEmpty) {
      final products = await ProductService.getAllProducts();
      productsProvider.homeAllProducts = products;
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
          }
          return buildBody();
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
        ProductsGrid(products: productsProvider.homeAllProducts),
      ],
    );
  }
}
