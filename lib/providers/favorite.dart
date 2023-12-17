import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/favorite.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<ProductModel> favoriteItems = []; // Store IDs of favorite items

  List<ProductModel> get favoriteIds => favoriteItems;
  FavoriteService favoriteService = FavoriteService();

  Future<void> addToFavorites(String userId, ProductModel product) async {
    favoriteItems.add(product);
    await favoriteService.addToFavorites(userId, product);
    notifyListeners();
  }

  // todo: Check item isfav or not bool ture or false
  Future<bool> checkIsFav(
      ProductModel product, List<ProductModel> allProducts) async {
    for (ProductModel p in favoriteItems) {
      if (p.id == product.id) {
        return true;
      }
    }
    return false;
  }

  Future getFavorites(userId, List<ProductModel> allProducts) async {
    favoriteItems = await favoriteService.getFavorites(userId, allProducts);
    notifyListeners();
  }

  Future<void> removeFromFavorites(String userId, ProductModel product) async {
    await favoriteService.removeProductFromFavorite(product, userId);
    notifyListeners();
  }
}
