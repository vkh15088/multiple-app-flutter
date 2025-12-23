/// Notification constants for reusable strings and default values
class NotificationConstants {
  NotificationConstants._(); // Private constructor to prevent instantiation

  // Notification Types
  static const String typeProduct = 'product';
  static const String typeProfile = 'profile';
  static const String typePromotion = 'promotion';
  static const String typeSettings = 'settings';
  static const String typeWelcome = 'welcome';
  static const String typeFeature = 'feature';
  static const String typeReminder = 'reminder';

  // FCM Topics
  static const String topicAll = 'all';
  static const String topicNews = 'news';
  static const String topicPromotions = 'promotions';
  static const String topicUpdates = 'updates';

  // Default Notification Titles
  static const String defaultProductTitle = 'Product Notification';
  static const String defaultProfileTitle = 'Profile Update';
  static const String defaultPromotionTitle = 'Special Offer';
  static const String defaultFeatureTitle = 'New Feature';
  static const String defaultReminderTitle = 'Reminder';

  // Default Notification Bodies
  static const String defaultProductBody = 'Check out this product!';
  static const String defaultProfileBody = 'Your profile has been updated';
  static const String defaultPromotionBody = 'Don\'t miss out on our special offer';
  static const String defaultFeatureBody = 'Discover our new feature';
  static const String defaultReminderBody = 'This is your reminder';

  // Default Product Values
  static const String defaultProductName = 'Product';
  static const String defaultProductPrice = '0.00';
  static const String defaultProductId = 'unknown';

  // Notification Data Keys
  static const String keyType = 'type';
  static const String keyId = 'id';
  static const String keyTitle = 'title';
  static const String keyBody = 'body';
  static const String keyProductName = 'product_name';
  static const String keyProductPrice = 'product_price';
  static const String keyUserId = 'user_id';
  static const String keySource = 'source';
  static const String keyNotificationData = 'notificationData';

  // Notification Sources
  static const String sourceLocal = 'local_notification';
  static const String sourcePush = 'push_notification';

  // Notification IDs
  static const int idWelcome = 1;
  static const int idPromotion = 2;
  static const int idFeature = 3;
  static const int idReminder = 4;
  static const int idScheduledReminder = 5;
  static const int idProduct = 999;
}
