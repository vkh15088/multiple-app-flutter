import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  Future<void> initialize() async {
    try {
      // Set config settings
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: kDebugMode ? const Duration(minutes: 1) : const Duration(hours: 12),
        ),
      );

      // Set default values
      await _remoteConfig.setDefaults({
        'welcome_message': 'Welcome to our app!',
        'enable_new_feature': false,
        'api_base_url': 'https://api.example.com',
        'maintenance_mode': false,
        'min_app_version': '1.0.0',
      });

      // Fetch and activate
      await _remoteConfig.fetchAndActivate();

      debugPrint('Remote Config initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Remote Config: $e');
    }
  }

  Future<void> fetchAndActivate() async {
    try {
      final updated = await _remoteConfig.fetchAndActivate();
      if (updated) {
        debugPrint('Remote Config values updated');
      } else {
        debugPrint('Remote Config values already up to date');
      }
    } catch (e) {
      debugPrint('Error fetching Remote Config: $e');
    }
  }

  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  // Feature flags
  bool isFeatureEnabled(String featureName) {
    return _remoteConfig.getBool('enable_$featureName');
  }

  bool isMaintenanceMode() {
    return _remoteConfig.getBool('maintenance_mode');
  }

  String getWelcomeMessage() {
    return _remoteConfig.getString('welcome_message');
  }

  String getApiBaseUrl() {
    return _remoteConfig.getString('api_base_url');
  }

  String getMinAppVersion() {
    return _remoteConfig.getString('min_app_version');
  }
}
