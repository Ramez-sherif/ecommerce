import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/user.dart';
class CartModel{
    const CartModel({required this.id,required this.products,required this.userId});
    final String id;
    final User userId;
    final List<MockProductModel> products;

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'products': products,
    };
  }
}