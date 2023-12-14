import 'package:ecommerce/providers/products.dart';
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
    productsProvider = Provider.of<ProductsProvider>(context, listen: true);
    WidgetsBinding.instance.addObserver(this);
  }

  Future getAllProducts() async {
    if (productsProvider.homeAllProducts.isEmpty) {
      await productsProvider.setHomeAllProducts();
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
