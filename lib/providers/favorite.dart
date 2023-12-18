import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/favorite.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<ProductModel> favoriteItems = [];

  Future getFavorites(userId, List<ProductModel> allProducts) async {
    favoriteItems = await FavoriteService.getFavorites(userId, allProducts);
    notifyListeners();
  }

  Future<void> addToFavorites(String userId, ProductModel product) async {
    favoriteItems.add(product);
    await FavoriteService.addToFavorites(userId, product);
    notifyListeners();
  }

  Future<void> removeFromFavorites(String userId, ProductModel product) async {
    favoriteItems.remove(product);
    await FavoriteService.removeProductFromFavorite(product, userId);
    notifyListeners();
  }

  Future<bool> checkIsFavourite(
    ProductModel product,
    List<ProductModel> allProducts,
  ) async {
    for (ProductModel p in favoriteItems) {
      if (p.id == product.id) {
        return true;
      }
    }
    return false;
  }
}
