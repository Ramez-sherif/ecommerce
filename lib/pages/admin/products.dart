import 'package:ecommerce/pages/admin/create_product.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:ecommerce/widgets/admin/products/products_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  Future getAllData() async {
    await getAllCategories();
    await getAllProducts();
  }

  Future getAllCategories() async {
    if (context.mounted) {
      await context.read<AdminProvider>().getAllCategories();
    }
  }

  Future getAllProducts() async {
    if (context.mounted) {
      await context.read<AdminProvider>().getAllProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return buildBody(context);
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
      },
    );
  }

  Scaffold buildBody(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const AdminProductsList(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Products'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AdminCreateProductPage(
                  categoriesList: context.watch<AdminProvider>().allCategories,
                ),
              ),
            );
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
