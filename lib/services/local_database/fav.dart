import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce/models/category.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/providers/favorite.dart';
import 'package:ecommerce/providers/home.dart';
import 'package:ecommerce/providers/user.dart';
import 'package:ecommerce/sqldb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

Future getFavorites(BuildContext context, SqlDb sqlDb) async {
  bool isConnected = await checkInternetConnectivity();
  if (context.mounted) {
    if (isConnected) {
      // Fetch favorites online
      List<ProductModel> allProducts =
          context.watch<HomeProvider>().homeAllProducts;

      String userId = context.read<UserProvider>().user.uid;

      await context.read<FavoriteProvider>().getFavorites(userId, allProducts);
    } else {
      // If no internet, fetch favorites from the local database
      String userId = context.read<UserProvider>().user.uid;
      List<Map> response2 = await sqlDb.readData("SELECT * FROM product");
      List<ProductModel> allProducts = [];
      List<Map> response = await sqlDb
          .readData("SELECT * FROM favorites WHERE userId = '$userId'");
      List<ProductModel> allFavorites = [];
      for (var item in response2) {
        allProducts.add(ProductModel(
            id: item['onlineProductId'],
            name: item['name'],
            description: "",
            image_URL: "",
            price: item['price'],
            rating: item['rate'],
            quantity: 0,
            category: CategoryModel(
                id: "", name: "", description: "", iconName: "")));
      }
      for (var item in response) {
        allFavorites.add(allProducts
            .firstWhere((element) => element.id == item["productId"]));
      }
      context.read<FavoriteProvider>().favoriteItems = allFavorites;
    }
  }
}

Future getAlfavorites(BuildContext context, SqlDb sqlDb) async {
  if (context.read<FavoriteProvider>().favoriteItems.isEmpty) {
    await getFavorites(context, sqlDb);
  }
}
