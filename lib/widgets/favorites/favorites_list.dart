// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/pages/item_details_page.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        String userId = context.read<UserProvider>().user.uid;
        await context.read<FavoriteProvider>().getFavorites(
              userId,
              context.read<HomeProvider>().homeAllProducts,
            );
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: context.watch<FavoriteProvider>().favoriteItems.length,
        itemBuilder: (context, index) => _buildProductItem(
          context,
          context.watch<FavoriteProvider>().favoriteItems[index],
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
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          String userId = context.read<UserProvider>().user.uid;
                          context
                              .read<FavoriteProvider>()
                              .removeFromFavorites(userId, product);
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    )
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
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
