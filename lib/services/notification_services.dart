import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:its_urgent_poc/secret.dart';
import 'package:its_urgent_poc/utils/snackbar.dart';

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _isNotificationPermission = false;

  Future<void> requestNotificationPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
    }
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _isNotificationPermission = true;
    } else {
      _isNotificationPermission = false;
    }
  }

  void firebaseInit() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message title: ${message.notification?.title.toString()}");
    });
  }

  void getApnToken() async {
    final apnsToken = await _firebaseMessaging.getAPNSToken();
    if (apnsToken != null) {
      print(apnsToken);
    } else {
      print("no apns token");
    }
  }

  static Future<String?> deviceToken() async {
    // It requests a registration token for sending messages to users from your App server or other trusted server environment.
    String? token = await FirebaseMessaging.instance.getToken();

    if (kDebugMode) {
      print('Registration Token=$token');
    }

    return token;
  }

  bool get isNotificationPermission => _isNotificationPermission;

  static void sendNotification(
    BuildContext context, {
    required String receiver,
    required String? sender,
  }) async {
    sender ??= "Admin";

    final data = {
      "notification": {
        "body": "This is an FCM notification message!",
        "title": "From: $sender",
        "sound": "default",
      },
      "to": receiver,
      "priority": "high",
    };

    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": auth
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      print('Error sending notification: $e');
      showSnackBar(context, 'Error sending notification: $e');
      // Handle the error, if needed
    }
  }
}
