import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    // Always request permission when the app starts
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("User granted permission: ${settings.authorizationStatus}");

    // Retrieve the FCM token after a 2-second delay
    Future.delayed(const Duration(seconds: 2), () async {
      try {
        String? token = await _messaging.getToken();
        print("FCM Token: $token");
      } catch (e) {
        print("Error retrieving FCM token: $e");
      }
    });

    // Listen for token refresh events
    _messaging.onTokenRefresh.listen((newToken) {
      print("FCM Token refreshed: $newToken");
    });

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a foreground message: ${message.messageId}");
      if (message.notification != null) {
        _showDialog(
          context,
          message.notification!.title ?? "No Title",
          message.notification!.body ?? "No Body",
        );
      }
    });

    // Listen for notification taps when the app is in the background.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User tapped on notification: ${message.messageId}");
    });
  }

  /// Displays an AlertDialog with the notification details.
  void _showDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
