import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product.dart';
import 'package:flutter/material.dart';

class PaymentProductWidget extends StatelessWidget {
  const PaymentProductWidget({
    super.key,
    required this.productModel,
    required this.quantity,
  });

  final ProductModel productModel;
  final int quantity;
  CachedNetworkImage getProductImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fill,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: getProductImage(
                productModel.image_URL,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  productModel.name,
                  style: const TextStyle(fontSize: 15.0),
                ),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${productModel.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
