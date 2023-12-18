import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String _phoneNumber = '';
  String _geoLocation = '';

  String get phoneNumber => _phoneNumber;
  String get geoLocation => _geoLocation;

  void updatePhoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    notifyListeners();
  }

  void updateGeoLocation(String newGeoLocation) {
    _geoLocation = newGeoLocation;
    notifyListeners();
  }
}
