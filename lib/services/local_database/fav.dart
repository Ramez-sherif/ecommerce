// ignore_for_file: avoid_print

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
          context.read<HomeProvider>().homeAllProducts;

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
      print("here");
      print(response2[0]);
      for (var item in response2) {
        allProducts.add(ProductModel(
            id: item['onlineProductId'],
            name: item['name'],
            description: "",
            image_URL: "",
            price: double.parse(item['price']),
            rating: double.parse(item['rate']),
            quantity: 0,
            category:
                CategoryModel(id: "", name: "", description: "", iconCode: 1),
            soldProducts: 0));
      }
      for (var item in response) {
        allFavorites.add(allProducts
            .firstWhere((element) => element.id == item["productId"]));
      }
      if (context.mounted) {
        context.read<FavoriteProvider>().favoriteItems = allFavorites;
      }
    }
  }
}

Future getAlfavorites(BuildContext context, SqlDb sqlDb) async {
  if (context.read<FavoriteProvider>().favoriteItems.isEmpty) {
    await getFavorites(context, sqlDb);
  }
}
