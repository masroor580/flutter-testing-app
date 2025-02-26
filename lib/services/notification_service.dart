import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initializes notifications:
  /// - Checks and prints that notification permissions are auto granted on Android 11.
  /// - Retrieves and prints the FCM token.
  /// - Listens for token refresh events.
  /// - Sets up listeners for foreground messages.
  Future<void> init(BuildContext context) async {
    // For Android devices below API level 33 (Android 13), notifications are automatically granted.
    if (Platform.isAndroid) {
      print("Running on Android. Notifications permission is automatically granted for Android 11.");
    } else {
      // For iOS (or other platforms), request permission explicitly.
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print("User granted permission: ${settings.authorizationStatus}");
    }

    // Retrieve and print the FCM token.
    try {
      String? token = await _messaging.getToken();
      print("FCM Token: $token");
    } catch (e) {
      print("Error retrieving FCM token: $e");
    }

    // Listen for token refresh events.
    _messaging.onTokenRefresh.listen((newToken) {
      print("FCM Token refreshed: $newToken");
    });

    // Listen for foreground messages.
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
// auth done