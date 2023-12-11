import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/widgets/favorites/favorites_list.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({Key? key}) : super(key: key);
  final List<ProductModel> favoriteItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FavoritesList(
            favoriteItems: favoriteItems,
          )
        ],
      ),
    );
  }
}
