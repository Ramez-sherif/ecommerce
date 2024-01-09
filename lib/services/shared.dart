// ignore_for_file: avoid_print

import 'package:ecommerce/services/collections_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharedService {
  static var db = FirebaseFirestore.instance;
  static Future<void> setFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    print("Saving fcmToken in SharedPreferences: $token");
    await prefs.setString('fcmToken', token);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('fcmToken');
    print("Getting fcmToken: $token");
    return token;
  }

  static Future<void> setRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    print("Saving role in SharedPreferences: $role");
    await prefs.setString('role', role);
  }

  static Future<String?> getUserRole(String uid) async {
    var data = await db.collection(CollectionConfig.users).doc(uid).get();
    SharedService.setRole(data['role']);
    return data['role'];
  }
}
