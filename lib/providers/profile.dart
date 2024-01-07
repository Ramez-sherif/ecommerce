import 'package:ecommerce/models/orders.dart';
import 'package:ecommerce/models/user.dart';
import 'package:ecommerce/services/orders.dart';
import 'package:ecommerce/services/profile.dart';
import 'package:ecommerce/services/user.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? userProfile;
   OrdersModel? mostRecentOrder;
  List<OrdersModel> allOrders = [];
  Future setUserProfile(String uid) async {
    userProfile = await UserService.getUserDetails(uid);
    notifyListeners();
  }

  Future updatePhoneNumber(String newPhoneNumber) async {
    userProfile!.number = newPhoneNumber;
    await ProfileService.updatePhoneNumber(userProfile!.uid, newPhoneNumber);
    notifyListeners();
  }

    Future updateGeoLocation(String newGeoLocation) async {
    userProfile!.location = newGeoLocation;
    await ProfileService.updateGeoLocation(userProfile!.uid, newGeoLocation);
    notifyListeners();
  }

  Future removeUser() async {
    userProfile = null;
    notifyListeners();
  }
  Future setAllOrders(String uid) async {
    allOrders = await OrdersService.getAllOrders(uid,userProfile!);
    notifyListeners();
  }


 Future<void> getMostRecentOrder(UserModel user) async {
    mostRecentOrder = await OrdersService.getMostRecentOrder(user);
    notifyListeners();
  }



  // void updateGeoLocation(String newGeoLocation) {
  //   _geoLocation = newGeoLocation;
  //   notifyListeners();
  // }
}
