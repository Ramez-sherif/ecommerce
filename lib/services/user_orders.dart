import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrdersService {
  static var db = FirebaseFirestore.instance;

  // Add a method to create a new order for the user
  static Future<void> createOrder(String userId, Map<String, dynamic> orderData) async {
    await db.collection('users').doc(userId).collection('orders').add(orderData);
  }

  // Add a method to update an existing order for the user
  static Future<void> updateOrder(String userId, String orderId, Map<String, dynamic> updatedOrderData) async {
    await db.collection('users').doc(userId).collection('orders').doc(orderId).update(updatedOrderData);
  }

  // Add a method to delete an existing order for the user
  static Future<void> deleteOrder(String userId, String orderId) async {
    await db.collection('users').doc(userId).collection('orders').doc(orderId).delete();
  }


  // Add a method to get user orders

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserOrders(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('created_at', descending: true)
        .snapshots();
  }
}
