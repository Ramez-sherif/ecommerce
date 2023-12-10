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
}

// password update - connected with the authetication ... 
// orders are sub-collection 
// frontend orders 