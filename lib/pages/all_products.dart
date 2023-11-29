// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ecommerce/widgets/all_products/categories_list.dart';
import 'package:ecommerce/widgets/all_products/products_grid.dart';
import 'package:ecommerce/widgets/all_products/top_bar.dart';
import 'package:flutter/material.dart';

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AllProductsTopBarWidget(),
        const CategoriesList(),
        const SizedBox(height: 10),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: const Text(
        //     'Products',
        //   ),
        // ),
        const ProductsGrid(),
      ],
    );
  }
}
