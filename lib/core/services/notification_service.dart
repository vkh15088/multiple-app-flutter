import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/notification_constants.dart';
import 'local_notification_service.dart';
import 'notification_navigation_helper.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  final SharedPreferences _prefs;
  final LocalNotificationService _localNotificationService;

  static const String _fcmTokenKey = 'fcm_token';
  static int _notificationIdCounter = 100; // Start from 100 for FCM notifications

  NotificationService(this._messaging, this._prefs, this._localNotificationService);

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
    await _setupMessageHandlers();

    // Subscribe to "all" topic for broadcast messages
    await subscribeToTopic(NotificationConstants.topicAll);
  }

  Future<void> _setupMessageHandlers() async {
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

  void _showLocalNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final data = message.data;

      if (notification == null) {
        debugPrint('No notification payload to display');
        return;
      }

      // Generate unique notification ID
      final notificationId = _notificationIdCounter++;

      // Prepare payload for navigation
      String payload;

      // If there's data, create JSON payload for better navigation
      if (data.isNotEmpty) {
        final payloadData = {
          NotificationConstants.keyType: data[NotificationConstants.keyType] ?? NotificationConstants.typePromotion,
          NotificationConstants.keyId: data[NotificationConstants.keyId] ?? data['product_id'] ?? '',
          NotificationConstants.keyTitle: notification.title ?? '',
          NotificationConstants.keyBody: notification.body ?? '',
          NotificationConstants.keyProductName: data[NotificationConstants.keyProductName] ?? '',
          NotificationConstants.keyProductPrice: data[NotificationConstants.keyProductPrice] ?? '',
          NotificationConstants.keySource: NotificationConstants.sourcePush,
        };
        payload = jsonEncode(payloadData);
      } else {
        // Simple payload if no data
        payload = NotificationConstants.typePromotion;
      }

      // Show local notification
      await _localNotificationService.showNotification(
        id: notificationId,
        title: notification.title ?? 'Notification',
        body: notification.body ?? 'You have a new message',
        payload: payload,
      );

      debugPrint('Local notification shown: ${notification.title}');
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    debugPrint('FCM notification tapped with data: $data');

    // Use centralized navigation helper
    NotificationNavigationHelper.handleFCMData(
      data,
      title: message.notification?.title,
      body: message.notification?.body,
    );
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
