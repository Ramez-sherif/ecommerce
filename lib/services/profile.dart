import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/user.dart' as userModel;
import 'package:ecommerce/providers/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileService {
  static Future<void> updatePhoneNumber(BuildContext context, String userId, String newPhoneNumber) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'phoneNumber': newPhoneNumber,
    });

    // Update the user provider after the Firestore update
    Provider.of<ProfileProvider>(context, listen: false).updatePhoneNumber(newPhoneNumber);
  }

  static Future<void> updateGeoLocation(BuildContext context, String userId, String newGeoLocation) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'geoLocation': newGeoLocation,
    });

    // Update the user provider after the Firestore update
    Provider.of<ProfileProvider>(context, listen: false).updateGeoLocation(newGeoLocation);
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

  Future<userModel.User> getUserDetails(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snap =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userModel.User.fromFirestore(snap);
    } catch (error) {
      // Handle errors appropriately (e.g., log or throw)
      print("Error fetching user details: $error");
      rethrow; // Re-throw the error for the calling code to handle
    }
  }
}
