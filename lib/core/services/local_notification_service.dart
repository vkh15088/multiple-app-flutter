import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_navigation_helper.dart';
import 'timezone_service.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final TimezoneService _timezoneService;

  static const String _channelId = 'default_channel';
  static const String _channelName = 'Default Notifications';
  static const String _channelDescription = 'General app notifications';

  LocalNotificationService(this._notificationsPlugin, this._timezoneService);

  Future<void> initialize() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Android initialization settings
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS initialization settings
      final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Initialization settings
      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      // Initialize
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions for iOS
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _requestIOSPermissions();
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        // await _requestAndroidPermissions();
      }

      // Create notification channels for Android
      await _createNotificationChannels();

      debugPrint('Local Notifications initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Local Notifications: $e');
    }
  }

  Future<void> _requestIOSPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _requestAndroidPermissions() async {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> _createNotificationChannels() async {
    // Default channel
    const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Importance channel
    const AndroidNotificationChannel importantChannel = AndroidNotificationChannel(
      'important_channel',
      'Important Notifications',
      description: 'Critical app notifications',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    // Create channels
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(defaultChannel);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(importantChannel);
  }

  // Callback when notification is tapped
  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    debugPrint('Local notification tapped with payload: $payload');

    // Use centralized navigation helper
    NotificationNavigationHelper.handlePayload(payload);
  }

  /// Show a simple notification
  Future<void> showNotification({required int id, required String title, required String body, String? payload}) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'notification_icon', // Must define, if not, it goes to exception
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _notificationsPlugin.show(id, title, body, notificationDetails, payload: payload);

      debugPrint('Notification shown: $title');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Show notification with big text (Android)
  Future<void> showBigTextNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: 'notification_icon', // Must define, if not, it goes to exception
        styleInformation: BigTextStyleInformation(body),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _notificationsPlugin.show(id, title, body, notificationDetails, payload: payload);
    } catch (e) {
      debugPrint('Error showing big text notification: $e');
    }
  }

  /// Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        icon: 'notification_icon', // Must define, if not, it goes to exception
        importance: Importance.high,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

      // Convert DateTime to TZDateTime using TimezoneService
      final tz.TZDateTime scheduledTZDate = _timezoneService.toLocalTZDateTime(scheduledDate);

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTZDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );

      debugPrint('Notification scheduled for: $scheduledDate (${scheduledTZDate.timeZoneName})');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    debugPrint('Notification cancelled: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    debugPrint('All notifications cancelled');
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  // Predefined notification templates
  Future<void> showWelcomeNotification() async {
    await showNotification(
      id: 1,
      title: '👋 Welcome!',
      body: 'Thanks for joining us. Explore amazing features!',
      payload: 'welcome',
    );
  }

  Future<void> showPromotionNotification() async {
    await showBigTextNotification(
      id: 2,
      title: '🎉 Special Offer!',
      body: 'Get 50% off on all premium features. Limited time offer. Don\'t miss out!',
      payload: 'promotion',
    );
  }

  Future<void> showFeatureNotification(String featureName) async {
    await showNotification(
      id: 3,
      title: '✨ New Feature Unlocked!',
      body: 'Check out our new $featureName feature',
      payload: 'feature:$featureName',
    );
  }

  Future<void> showReminderNotification(String message) async {
    await showNotification(id: 4, title: '⏰ Reminder', body: message, payload: 'reminder');
  }

  Future<void> scheduleReminderNotification({required String message, required DateTime scheduledDate}) async {
    await scheduleNotification(
      id: 5,
      title: '⏰ Scheduled Reminder',
      body: message,
      scheduledDate: scheduledDate,
      payload: 'scheduled_reminder',
    );
  }
}
