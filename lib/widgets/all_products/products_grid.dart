// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/item_details_page.dart';
import 'package:ecommerce/providers/products.dart';
import 'package:ecommerce/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductsProvider productsProvider = Provider.of<ProductsProvider>(
      context,
      listen: true,
    );

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await productsProvider.setHomeAllProducts();
        },
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          physics: const AlwaysScrollableScrollPhysics(),
          children: List.generate(
            productsProvider.homeAllProducts.length,
            (index) => _buildProductItem(
                context, productsProvider.homeAllProducts[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, ProductModel product) {
    var boxDecoration = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
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
                    Text(
                      '${product.name.capitalize()} \n\$${product.price}',
                      style: textStyle,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
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
