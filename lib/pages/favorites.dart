import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/widgets/favorites/favorites_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<ProductModel> favoriteItems = [];

  Future getAlfavorites() async {
    if (context.read<FavoriteProvider>().favoriteItems.isEmpty) {
      List<ProductModel> allProducts =
          context.watch<HomeProvider>().homeAllProducts;
      String userId = await context.read<UserProvider>().user.uid;
      await context.read<FavoriteProvider>().getFavorites(userId, allProducts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAlfavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return buildBody();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Scaffold buildBody() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FavoritesList(
            favoriteItems: context.watch<FavoriteProvider>().favoriteItems,
          )
        ],
      ),
    );
  }
}
