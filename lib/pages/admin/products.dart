import 'package:ecommerce/pages/admin/create_product.dart';
import 'package:ecommerce/providers/admin.dart';
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
  }

  Future<void> getAllCategories() async {
    if (context.mounted) {
      await context.read<AdminProvider>().getAllCategories();
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
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminCreateProductPage(
                    categoriesList:
                        context.watch<AdminProvider>().allCategories,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Product1'),
            Text('Product2'),
          ],
        ),
      ),
    );
  }
}
