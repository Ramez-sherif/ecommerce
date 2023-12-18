import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  Future<void> updatePhoneNumber(String userId, String newPhoneNumber) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'phoneNumber': newPhoneNumber,
    });
  }

  Future<void> updateGeoLocation(String userId, String newGeoLocation) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'geoLocation': newGeoLocation,
    });
  }

  // Add a method to update the password connected with authentication
  Future<void> updatePassword(String userId, String newPassword) async {
    // You can implement authentication-related logic here
    // For example, you might want to use Firebase Authentication APIs
    // to update the user's password.
    // This method should handle the authentication-specific password update logic.
  }

}
