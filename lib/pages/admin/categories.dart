import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/pages/admin/create_category.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:ecommerce/widgets/admin/categories/category_dismissable_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCategoriesPage extends StatefulWidget {
  const AdminCategoriesPage({super.key});

  @override
  State<AdminCategoriesPage> createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  Future getAllCategories() async {
    if (context.mounted) {
    if (context.read<AdminProvider>().allCategories.isEmpty) {
      await context.read<AdminProvider>().getAllCategories();
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminCreateCategoryPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getAllCategories(),
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
              return buildBody();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          }
        },
      ),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: () async {
          await context.read<AdminProvider>().getAllCategories();
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: context.watch<AdminProvider>().allCategories.length,
          itemBuilder: (context, index) {
            CategoryModel category =
                context.watch<AdminProvider>().allCategories[index];

            return CategoryDismissableItem(
              category: category,
            );
          },
        ),
      ),
    );
  }
}
