import 'package:ecommerce/models/cart.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/cart.dart';
import 'package:ecommerce/services/product.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  List<ProductModel> homeAllProducts = [];
  CartModel? cartProducts;

  Future setHomeAllProducts() async {
    final products = await ProductService.getAllProducts();
    homeAllProducts = products;
    notifyListeners();
  }

  Future setCartProducts(String userId) async {
    cartProducts = await CartService.getCart(userId);
    notifyListeners();
  }
}
