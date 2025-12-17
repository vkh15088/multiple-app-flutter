import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  final SharedPreferences _prefs;

  static const String _fcmTokenKey = 'fcm_token';

  NotificationService(this._messaging, this._prefs);

  Future<void> initialize() async {
    // Request permission for iOS
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true, provisional: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
      return;
    }

    // Get FCM token
    final token = await _messaging.getToken();
    if (token != null) {
      await _saveFCMToken(token);
      debugPrint('FCM Token: $token');
    }

    // Listen to token refresh
    _messaging.onTokenRefresh.listen(_saveFCMToken);

    // Setup message handlers
    _setupMessageHandlers();
  }

  void _setupMessageHandlers() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        _showLocalNotification(message);
      }
    });

    // Message opened app from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A message opened the app!');
      _handleNotificationTap(message);
    });

    // Check if app was opened from terminated state
    _messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App opened from terminated state!');
        _handleNotificationTap(message);
      }
    });
  }

  Future<void> _saveFCMToken(String token) async {
    await _prefs.setString(_fcmTokenKey, token);
    // TODO: Send token to your backend server
  }

  String? getFCMToken() {
    return _prefs.getString(_fcmTokenKey);
  }

  void _showLocalNotification(RemoteMessage message) {
    // TODO: Implement local notification display
    // You can use flutter_local_notifications package
    debugPrint('Showing notification: ${message.notification?.title}');
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Handle notification tap and navigate accordingly
    final data = message.data;
    debugPrint('Notification tapped with data: $data');

    // TODO: Implement navigation based on notification data
    // Example: Navigate to specific screen based on data['route']
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}
