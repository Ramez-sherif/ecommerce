// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/item_details_page.dart';
import 'package:ecommerce/providers/admin.dart';
import 'package:ecommerce/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminProductsList extends StatelessWidget {
  const AdminProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<AdminProvider>().getAllProducts();
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: context.watch<AdminProvider>().allProducts.length,
        itemBuilder: (context, index) => _buildProductItem(
          context,
          context.watch<AdminProvider>().allProducts[index],
        ),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, ProductModel product) {
    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary,
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: getProductImage(product.image_URL),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.name.capitalize()}\n\$${product.price}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // show category name
                    Icon(
                      IconData(
                        product.category.iconCode,
                        fontFamily: 'MaterialIcons',
                      ),
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CachedNetworkImage getProductImage(String image_URL) {
    return CachedNetworkImage(
      imageUrl: image_URL,
      fit: BoxFit.fitWidth,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
