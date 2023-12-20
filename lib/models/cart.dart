import 'package:ecommerce/models/product.dart';

class CartModel {
  const CartModel({required this.userId, required this.products});
  final String userId; //should be from object from class user
  final Map<ProductModel, int> products;
}
