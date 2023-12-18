import 'package:cloud_firestore/cloud_firestore.dart';
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
    // You can implement authentication-related logic here
    // For example, you might want to use Firebase Authentication APIs
    // to update the user's password.
    // This method should handle the authentication-specific password update logic.
  }
}


