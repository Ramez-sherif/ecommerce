// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static Future<void> setFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    print("Saving fcmToken: $token");
    await prefs.setString('fcmToken', token);
  }

  static Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('fcmToken');
    print("Getting fcmToken: $token");
    return token;
  }
}
