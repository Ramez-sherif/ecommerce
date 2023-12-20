// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/item_details_page.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<HomeProvider>().setHomeAllProducts();
      },
      child: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        physics: const AlwaysScrollableScrollPhysics(),
        children: List.generate(
          context.watch<HomeProvider>().homeAllProducts.length,
          (index) => _buildProductItem(
            context,
            context.watch<HomeProvider>().homeAllProducts[index],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, ProductModel product) {
    var boxDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.secondary,
          spreadRadius: 1,
          blurRadius: 3,
        ),
      ],
    );

    const textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return IntrinsicHeight(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                body: ItemDetailsPage(
                  product: product,
                ),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: boxDecoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product image
              Expanded(
                flex: 3,
                child: getProductImage(product.image_URL),
              ),
              // product name and price
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product.name.capitalize(),
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                    Text(
                      '\$${product.price}',
                      style: textStyle,
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
      fit: BoxFit.fill,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
