// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:ecommerce/widgets/all_products/top_bar.dart';
import 'package:flutter/material.dart';

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AllProductsTopBarWidget(),
      ],
    );
  }
}
