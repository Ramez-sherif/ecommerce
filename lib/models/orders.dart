import 'package:ecommerce/models/product.dart';

class OrdersModel{
  const OrdersModel({required this.userId, required this.products,required this.orderTime});
  final String userId; //should be from object from class user
  final Map<ProductModel, int> products;
  final DateTime orderTime;
}