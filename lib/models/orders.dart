import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/models/user.dart';

class OrdersModel {
  OrdersModel(
      {required this.user,
      required this.products,
      required this.date,
      required this.orderId,
      required this.status});
  final String orderId;
  final UserModel user; //should be from object from class user
  final Map<ProductModel, int> products;
  final DateTime date;
  String status;
}
