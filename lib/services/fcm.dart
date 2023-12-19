import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/models/response.dart';
import 'package:ecommerce/services/shared.dart';
import 'package:http/http.dart' as http;

class FCMService {
  static var db = FirebaseFirestore.instance;

  static Future<ResponseModel> sendNotification(
    String deviceToken,
    String title,
    String body,
  ) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    String serverKey =
        "AAAAyMRZjzg:APA91bFWH7o0m1t2JPtnnpW1qrQhcuRCq668QP6rJiIlldRyDOoM2eR32OBCbhK7jXEABfJzFOpweyJ8j3mlayfi48_Zng4jj90oYJKm9WY1PI2z-kBka7nvpIkN9e_jxd85PBIsDdDR";

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = {
      'notification': {
        'title': title,
        'body': body,
      },
      'to': deviceToken,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return ResponseModel(
        status: true,
        message: 'Notification sent successfully.',
      );
    } else {
      return ResponseModel(
        status: false,
        message: 'Notification sending failed. Please try again.',
      );
    }
  }

  static Future<List<String>> getAllFCMTokens() async {
    List<String> fcmTokens = [];

    try {
      var querySnapshot = await db.collection("users").get();

      for (var doc in querySnapshot.docs) {
        if (doc.data().containsKey('fcm_token')) {
          fcmTokens.add(doc.data()['fcm_token']);
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return fcmTokens;
  }

  static Future setFCMToken(String userId) async {
    String? fcmToken = await SharedService.getFcmToken();
    try {
      await db
          .collection("users")
          .doc(userId)
          .set({'fcm_token': fcmToken}, SetOptions(merge: true));
    } catch (e) {
      log(e.toString());
    }
  }
}
