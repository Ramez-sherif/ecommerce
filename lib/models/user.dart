import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/order.dart' as orderModel; // Use an alias for the import

class User {
  final String email;
  final String uid;
  final String? username;
  final String? password;
  final String? number;
  final String? location;
  final String? role; // Added 'role' property
  final List<orderModel.Order> orders; // Added 'orders' property

  User({
    required this.email,
    required this.uid,
    this.username,
    this.password,
    this.number,
    this.location,
    this.role,
    List<orderModel.Order>? orders, // Use correct type and make it nullable
  }) : orders = orders ?? []; // Initialize 'orders' in the constructor

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

  factory User.fromMap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final List<Map<String, dynamic>> ordersData =
        List<Map<String, dynamic>>.from(data['orders'] ?? []);
    final List<orderModel.Order> orders = ordersData.map((orderData) {
      return orderModel.Order.fromMap(orderData); // Use alias consistently
    }).toList();

    return User(
      email: data['email'] as String? ?? '',
      uid: data['uid'] as String? ?? '',
      username: data['username'] as String?,
      password: data['password'] as String?,
      number: data['number'] as String?,
      location: data['location'] as String?,
      role: data['role'] as String?,
      orders: orders,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(
        json.decode(source) as DocumentSnapshot<Map<String, dynamic>>,
      );
}
