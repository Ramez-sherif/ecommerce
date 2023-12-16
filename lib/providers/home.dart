import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/services/product.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  List<ProductModel> homeAllProducts = [];

  Future setHomeAllProducts() async {
    final products = await ProductService.getAllProducts();
    homeAllProducts = products;
    notifyListeners();
  }
}
