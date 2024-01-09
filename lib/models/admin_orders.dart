import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/status.dart';

class AdminOrders{
  final OrdersModel order;
  final double totalPrice;
  final StatusModel status;

  AdminOrders({
    required this.order,
    required this.totalPrice,
    required this.status,
  });
}