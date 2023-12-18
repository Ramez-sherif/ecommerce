import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/services/profile.dart';
import 'package:ecommerce/services/user.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? userProfile;

  Future setUserProfile(String uid) async {
    userProfile = await UserService.getUserDetails(uid);
    notifyListeners();
  }

  Future updatePhoneNumber(String newPhoneNumber) async {
    userProfile!.number = newPhoneNumber;
    await ProfileService.updatePhoneNumber(userProfile!.uid, newPhoneNumber);
    notifyListeners();
  }

  Future removeUser() async {
    userProfile = null;
    notifyListeners();
  }

  // void updateGeoLocation(String newGeoLocation) {
  //   _geoLocation = newGeoLocation;
  //   notifyListeners();
  // }
}
