
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/services/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CategoriesList extends StatefulWidget{
const CategoriesList({Key? key}) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}
class _CategoriesListState extends  State<CategoriesList>  {
  
  // make a list of categories
  Future<List<Widget>> getBuildCategories() async {
    List<CategoryModel> categories = await CategoryService.getAllCategories();
    List<Widget> buildCategories = [_buildCategoryItem(CategoryModel(id: "0", name: "All", description: "AllProducts", iconName: "list"))];
    for (var category in categories) {
      buildCategories.add(_buildCategoryItem(category));
    }
    return buildCategories;
  }
  Future setHomeProductsByCategory(String categoryId) async{
      await context.read<HomeProvider>().setHomeAllProducts(categoryId: categoryId);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBuildCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Widget> categories = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: categories,
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  Widget _buildCategoryItem(CategoryModel category) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: IconButton(
              onPressed: () async {
                await context
                    .read<HomeProvider>()
                    .setHomeAllProducts(categoryId: category.id);
              },
              icon: Icon(
                category.icon,
                color: Colors.black,
                size: 40,
              ),
            ),
          ),
        ),
         Text(
          category.name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
