import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/services/cart.dart';

class CartModel {
  const CartModel({required this.userId, required this.products});
  final String userId; //should be from object from class user
  final Map<ProductModel, int> products;

  List<Map<String, dynamic>> toMap() {
    List<Map<String, dynamic>> map = [];
    for (var product in products.entries) {
      map.add({
        "user_id": userId, //should be user.id
        "quantity": products[product.key],
        "product_id": product.key.id
      });
    }
    return map;
  }
}
