import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/item_details_page.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;
  const ProductsGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        physics: const BouncingScrollPhysics(),
        children: List.generate(
          products.length,
          (index) => _buildProductItem(context, products[index]),
        ),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, ProductModel product) {
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
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  // child: Image(
                  //   image: CachedNetworkImageProvider(
                  //     product.image_URL,
                  //   ),
                  //   fit: BoxFit.fill,
                  // ),
                  child: CachedNetworkImage(
                    imageUrl: product.image_URL,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Text(
                '${product.name.capitalize()} \n\$${product.price}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
