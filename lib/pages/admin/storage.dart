import 'package:ecommerce/pages/admin/categories.dart';
import 'package:ecommerce/pages/admin/products.dart';
import 'package:flutter/material.dart';

class AdminStoragePage extends StatefulWidget {
  const AdminStoragePage({super.key});

  @override
  State<AdminStoragePage> createState() => _AdminStoragePageState();
}

class _AdminStoragePageState extends State<AdminStoragePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildItem(context, 'Products', const AdminProductsPage()),
          buildItem(context, 'Categories', const AdminCategoriesPage()),
        ],
      ),
    );
  }

  Container buildItem(BuildContext context, String title, Widget page) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
