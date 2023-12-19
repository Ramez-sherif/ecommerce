import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/services/collections_config.dart';
import 'package:flutter/material.dart';

class ProfileService {
  static Future<void> updatePhoneNumber(String userId, String newPhoneNumber,) async {
    await FirebaseFirestore.instance
        .collection(CollectionConfig.users)
        .doc(userId)
        .update({
      'number': newPhoneNumber,
    });
  }

  static Future<void> updateGeoLocation(String userId, String newGeoLocation) async {
    await FirebaseFirestore.instance
        .collection(CollectionConfig.users)
        .doc(userId)
        .update({
      'location': newGeoLocation,
    });
  }

  // Add a method to update the password connected with authentication
  // You can also notify the provider here if needed.
  Future<void> updatePassword(String userId, String newPassword) async {
    try {
      // Implement authentication-related logic to update the user's password
      // For example, if using Firebase Authentication, you might use:
      // await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);

      // Add logic to update the password in the backend
    } catch (error) {
      // Handle errors appropriately (e.g., log or throw)
      print("Error updating password: $error");
      rethrow; // Re-throw the error for the calling code to handle
    }
  }

  Future<UserModel> getUserDetails(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return UserModel.fromFirestore(snap);
    } catch (error) {
      // Handle errors appropriately (e.g., log or throw)
      print("Error fetching user details: $error");
      rethrow; // Re-throw the error for the calling code to handle
    }
  }
}
