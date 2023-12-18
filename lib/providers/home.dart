import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/services/product.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  List<ProductModel> homeAllProducts = [];
  List<ProductModel> allProducts = [];
  CartModel? cartProducts;

  Future setHomeAllProducts() async {
    final products = await ProductService.getAllProducts();
    homeAllProducts = products;
    allProducts = products;
    notifyListeners();
  }

  Future setCartProducts(String userId) async {
    cartProducts = await CartService.getCart(userId, homeAllProducts);
    notifyListeners();
  }

  Future addProductToCart(
      ProductModel product, String userId, int quantity) async {
    await CartService.addProductToCart(product.id, userId, quantity);
    cartProducts!.products[product] = 1;
    notifyListeners();
  }

  Future removeProductFromCart(ProductModel product, String userId) async {
    await CartService.removeProductFromCart(product, userId);
    cartProducts!.products.remove(product);
    notifyListeners();
  }

  Future updateProductQuantity(
      ProductModel product, String userId, int quantity) async {
    await CartService.updateProductQuantity(product.id, userId, quantity);
    cartProducts!.products[product] = quantity;
    notifyListeners();
  }

  void searchProducts(String query) {
    List<ProductModel> products;
    if (query.isNotEmpty) {
      products = allProducts
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.category.name
                    .toLowerCase()
                    .contains(query.toLowerCase()),
          )
          .toList();
    } else {
      products = allProducts;
    }
    homeAllProducts = products;
    notifyListeners();
  }
}
