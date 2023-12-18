import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/order.dart' as orderModel;

class User {
  final String email;
  final String uid;
  final String? username;
  final String? password;
  final String? number;
  final String? location;
  final String? role;
  final List<orderModel.Order> orders;

  User({
    required this.email,
    required this.uid,
    this.username,
    this.password,
    String? number,
    String? location,
    this.role,
    List<orderModel.Order>? orders,
  })   : this.number = number ?? null,
        this.location = location ?? null,
        this.orders = orders ?? [];

  String? get phoneNumber => number;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
      'username': username,
      'password': password,
      'number': number,
      'location': location,
      'role': role,
      'orders': orders.map((order) => order.toMap()).toList(),
    };
  }

   factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final List<Map<String, dynamic>> ordersData =
        List<Map<String, dynamic>>.from(data['orders'] ?? []);
    final List<orderModel.Order> orders = ordersData.map((orderData) {
      return orderModel.Order.fromMap(orderData);
    }).toList();

    return User(
      email: data['email'] as String? ?? '',
      uid: data['uid'] as String? ?? '',
      username: data['username'] as String?,
      password: data['password'] as String?,
      number: data['number'] as String? ?? '',
      location: data['location'] as String? ?? '',
      role: data['role'] as String?,
      orders: orders,
    );
  }

  String toJson() => json.encode(toMap());

  // factory User.fromJson(String source) => User.fromMap(
  //       json.decode(source) as DocumentSnapshot<Map<String, dynamic>>,
  //     );
}
