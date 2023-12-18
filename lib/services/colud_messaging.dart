// ignore_for_file: avoid_print, body_might_complete_normally_nullable

import 'package:ecommerce/services/shared.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CloudMessaging {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    final notificationSettings =
        await _firebaseMessaging.requestPermission(provisional: true);

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      final fcmToken = await getFcmToken();

      //on token refresh
      await onTokenRefresh(fcmToken!);

      print('fcmToken: $fcmToken');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> onTokenRefresh(String fcmToken) async {
    await SharedService.setFcmToken(fcmToken);
  }

  Future<String?> getFcmToken() async {
    await _firebaseMessaging.requestPermission();
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      await listenToForegroundMessage();
      return fcmToken;
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> listenToForegroundMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message title: ${message.notification!.title}');
      print('Message body: ${message.notification!.body}');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
      showForgroundNotification(message);
    });
  }

  Future<void> showForgroundNotification(RemoteMessage message) async {
    var androidChannel = const AndroidNotificationChannel(
      'channel_id',
      'Channel Name',
      importance: Importance.max,
    );

    var androidNotificationDetails = AndroidNotificationDetails(
      androidChannel.id,
      androidChannel.name,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      //payload: message.data['route'],
    );
  }
}
