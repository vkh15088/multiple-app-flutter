import '../constants/notification_constants.dart';

/// Model class for notification data
/// Provides type-safe access to notification information
class NotificationData {
  final String title;
  final String body;
  final String? productName;
  final String? productPrice;
  final String? source;
  final Map<String, dynamic>? rawData;

  const NotificationData({
    required this.title,
    required this.body,
    this.productName,
    this.productPrice,
    this.source,
    this.rawData,
  });

  /// Create NotificationData from a map
  factory NotificationData.fromMap(Map<String, dynamic> data) {
    return NotificationData(
      title: data[NotificationConstants.keyTitle] as String? ?? NotificationConstants.defaultProductTitle,
      body: data[NotificationConstants.keyBody] as String? ?? NotificationConstants.defaultProductBody,
      productName: data[NotificationConstants.keyProductName] as String?,
      productPrice: data[NotificationConstants.keyProductPrice] as String?,
      source: data[NotificationConstants.keySource] as String?,
      rawData: data,
    );
  }

  /// Create a product notification data
  factory NotificationData.product({
    String? title,
    String? body,
    String? productName,
    String? productPrice,
    Map<String, dynamic>? additionalData,
  }) {
    return NotificationData(
      title: title ?? NotificationConstants.defaultProductTitle,
      body: body ?? NotificationConstants.defaultProductBody,
      productName: productName ?? NotificationConstants.defaultProductName,
      productPrice: productPrice ?? NotificationConstants.defaultProductPrice,
      source: NotificationConstants.sourceLocal,
      rawData: additionalData,
    );
  }

  /// Convert to map for navigation extra data
  Map<String, dynamic> toMap() {
    return {
      NotificationConstants.keyTitle: title,
      NotificationConstants.keyBody: body,
      if (productName != null) NotificationConstants.keyProductName: productName,
      if (productPrice != null) NotificationConstants.keyProductPrice: productPrice,
      if (source != null) NotificationConstants.keySource: source,
      if (rawData != null) NotificationConstants.keyNotificationData: rawData,
    };
  }

  /// Create a copy with updated fields
  NotificationData copyWith({
    String? title,
    String? body,
    String? productName,
    String? productPrice,
    String? source,
    Map<String, dynamic>? rawData,
  }) {
    return NotificationData(
      title: title ?? this.title,
      body: body ?? this.body,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      source: source ?? this.source,
      rawData: rawData ?? this.rawData,
    );
  }
}
