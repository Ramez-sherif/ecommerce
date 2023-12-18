import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_product.dart';

class Order {
  final DateTime created_at;
  final String status;
  final double total_price;
  final List<OrderProduct> orderProducts;

  Order({
    required this.created_at,
    required this.status,
    required this.total_price,
    this.orderProducts = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'created_at': Timestamp.fromDate(created_at),
      'status': status,
      'total_price': total_price,
      'orderProducts': orderProducts.map((product) => product.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final List<Map<String, dynamic>> orderProductsData =
        List<Map<String, dynamic>>.from(map['orderProducts'] ?? []);
    final List<OrderProduct> orderProducts = orderProductsData.map((productData) {
      return OrderProduct.fromMap(productData);
    }).toList();

    return Order(
      created_at: (map['created_at'] as Timestamp).toDate(),
      status: map['status'] as String,
      total_price: (map['total_price'] as num).toDouble(),
      orderProducts: orderProducts,
    );
  }
}
