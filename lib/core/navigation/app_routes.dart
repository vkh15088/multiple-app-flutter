/// App route paths and names
/// Centralized location for all route definitions
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Route Paths
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String product = '/product/:id';
  static const String profile = '/profile/:id';
  static const String settings = '/settings';

  // Route Names (for named navigation)
  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String homeName = 'home';
  static const String productName = 'product';
  static const String profileName = 'profile';
  static const String settingsName = 'settings';

  // Helper methods to generate paths with parameters
  static String productPath(String id) => '/product/$id';
  static String profilePath(String id) => '/profile/$id';

  // All route paths as a list (useful for checks)
  static const List<String> allPaths = [login, signup, home, product, profile, settings];
}
