// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/product_review_page.dart';
import 'package:ecommerce/utils/string_extensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsWidget extends StatefulWidget {
  final bool isFavorite;
  final Function toggleFavorite;
  final ProductModel product;
  const ProductDetailsWidget({
    super.key,
    required this.isFavorite,
    required this.toggleFavorite,
    required this.product,
  });

  @override
  State<ProductDetailsWidget> createState() => _productDetailsWidgetState();
}

class _productDetailsWidgetState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite ? Colors.red : null,
              ),
              iconSize: 40.0,
              onPressed: () {
                widget.toggleFavorite();
              },
            ),
            Flexible(
              child: Text(
                widget.product.name.capitalize(),
                style: const TextStyle(
                    fontSize: 35.0, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.star),
                  color: Colors.yellow,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductReviewPage(
                          product: widget.product,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 4.0),
                Text(
                  widget.product.rating.toString(),
                  style: const TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Center(
          child: getProductImage(widget.product.image_URL),
        ),
        const SizedBox(height: 25.0),
        Text(
          widget.product.description,
          style: const TextStyle(fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ],
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
