import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../constants/notification_constants.dart';
import '../models/notification_data.dart';
import '../navigation/app_router.dart';
import '../navigation/app_routes.dart';

/// Centralized notification navigation handler
/// Used by both NotificationService (FCM) and LocalNotificationService
class NotificationNavigationHelper {
  /// Handle navigation from notification payload (String format)
  static void handlePayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      debugPrint('Empty payload, no navigation');
      return;
    }

    try {
      // Parse payload (can be simple string or JSON)
      if (payload.startsWith('{')) {
        // JSON payload
        final data = Map<String, dynamic>.from(const JsonDecoder().convert(payload) as Map);
        _handleJsonPayload(data);
      } else if (payload.contains(':')) {
        // Simple key:value format (e.g., "product:123")
        final parts = payload.split(':');
        final type = parts[0];
        final id = parts.length > 1 ? parts[1] : '';
        _handleSimplePayload(type, id);
      } else {
        // Single word payload
        _handleSimplePayload(payload, '');
      }
    } catch (e) {
      debugPrint('Error parsing notification payload: $e');
      AppRouter.router.go(AppRoutes.home);
    }
  }

  /// Handle navigation from FCM RemoteMessage data
  static void handleFCMData(Map<String, dynamic> data, {String? title, String? body}) {
    try {
      final type = data[NotificationConstants.keyType] as String?;

      switch (type) {
        case NotificationConstants.typeProduct:
          final productId =
              data['product_id'] as String? ??
              data[NotificationConstants.keyId] as String? ??
              NotificationConstants.defaultProductId;

          final notificationData = NotificationData(
            title:
                title ?? data[NotificationConstants.keyTitle] as String? ?? NotificationConstants.defaultProductTitle,
            body: body ?? data[NotificationConstants.keyBody] as String? ?? NotificationConstants.defaultProductBody,
            productName:
                data[NotificationConstants.keyProductName] as String? ?? NotificationConstants.defaultProductName,
            productPrice:
                data[NotificationConstants.keyProductPrice] as String? ?? NotificationConstants.defaultProductPrice,
            source: NotificationConstants.sourcePush,
            rawData: data,
          );

          AppRouter.router.go(AppRoutes.productPath(productId), extra: notificationData.toMap());
          break;

        case NotificationConstants.typeProfile:
          final userId = data[NotificationConstants.keyUserId] as String? ?? 'me';
          AppRouter.router.go(AppRoutes.profilePath(userId));
          break;

        case NotificationConstants.typePromotion:
          AppRouter.router.go(AppRoutes.home);
          break;

        case NotificationConstants.typeSettings:
          AppRouter.router.go(AppRoutes.settings);
          break;

        default:
          debugPrint('Unknown notification type: $type, navigating to home');
          AppRouter.router.go(AppRoutes.home);
      }
    } catch (e) {
      debugPrint('Error handling FCM notification: $e');
      AppRouter.router.go(AppRoutes.home);
    }
  }

  /// Handle JSON payload navigation
  static void _handleJsonPayload(Map<String, dynamic> data) {
    final type = data[NotificationConstants.keyType] as String?;
    final id = data[NotificationConstants.keyId] as String?;

    switch (type) {
      case NotificationConstants.typeProduct:
        final notificationData = NotificationData.fromMap(data);
        AppRouter.router.go(
          AppRoutes.productPath(id ?? NotificationConstants.defaultProductId),
          extra: notificationData.toMap(),
        );
        break;

      case NotificationConstants.typeProfile:
        AppRouter.router.go(AppRoutes.profilePath(id ?? 'me'));
        break;

      case NotificationConstants.typeSettings:
        AppRouter.router.go(AppRoutes.settings);
        break;

      default:
        AppRouter.router.go(AppRoutes.home);
    }
  }

  /// Handle simple payload navigation
  static void _handleSimplePayload(String type, String id) {
    switch (type) {
      case NotificationConstants.typeProduct:
        final notificationData = NotificationData.product(productName: id.isNotEmpty ? 'Product $id' : null);
        AppRouter.router.go(
          AppRoutes.productPath(id.isNotEmpty ? id : NotificationConstants.defaultProductId),
          extra: notificationData.toMap(),
        );
        break;

      case NotificationConstants.typeProfile:
        AppRouter.router.go(AppRoutes.profilePath(id.isNotEmpty ? id : 'me'));
        break;

      case NotificationConstants.typeWelcome:
      case NotificationConstants.typePromotion:
      case NotificationConstants.typeFeature:
      case NotificationConstants.typeReminder:
      case 'scheduled_reminder':
        AppRouter.router.go(AppRoutes.home);
        break;

      default:
        AppRouter.router.go(AppRoutes.home);
    }
  }
}
