import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/order.dart';

class UserModel {
  final String uid;
  final String email;
  String username;
  String number;
  String location;
  final String role;
  List<OrderModel>? orders;

  UserModel({
    required this.email,
    required this.uid,
    required this.username,
    required this.number,
    required this.location,
    required this.role,
    this.orders,
  });

  String? get phoneNumber => number;

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'uid': uid,
      'username': username,
      'number': number,
      'location': location,
      'role': role,
    };
  }

  factory UserModel.createEmptyUser(String uid, String email) {
    return UserModel(
      uid: uid,
      email: email,
      username: email.split('@')[0],
      number: '',
      location: '',
      role: 'user',
    );
  }
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;

    List<OrderModel> orders = [];

    // check if there collection orders exists
    if (data['orders'] != null) {
      final List<Map<String, dynamic>> ordersData =
          List<Map<String, dynamic>>.from(data['orders']);

      orders = ordersData.map((orderData) {
        return OrderModel.fromMap(orderData);
      }).toList();
    }

    return UserModel(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      number: data['number'],
      location: data['location'],
      role: data['role'],
      orders: orders,
    );
  }
}
