import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for initializing and managing timezone configuration
class TimezoneService {
  static bool _isInitialized = false;

  /// Initialize timezone database and set local timezone
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone database with latest data
    tz.initializeTimeZones();

    // Get device timezone
    final TimezoneInfo currentTimeZone = await FlutterTimezone.getLocalTimezone();

    // Set local timezone location using the identifier
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));

    _isInitialized = true;
  }

  /// Get current timezone location
  tz.Location getCurrentLocation() {
    if (!_isInitialized) {
      throw Exception('TimezoneService not initialized. Call initialize() first.');
    }
    return tz.local;
  }

  /// Get timezone location by name
  tz.Location getLocation(String timezoneName) {
    if (!_isInitialized) {
      throw Exception('TimezoneService not initialized. Call initialize() first.');
    }
    return tz.getLocation(timezoneName);
  }

  /// Convert DateTime to TZDateTime in local timezone
  tz.TZDateTime toLocalTZDateTime(DateTime dateTime) {
    if (!_isInitialized) {
      throw Exception('TimezoneService not initialized. Call initialize() first.');
    }
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  /// Convert DateTime to TZDateTime in specific timezone
  tz.TZDateTime toTZDateTime(DateTime dateTime, String timezoneName) {
    if (!_isInitialized) {
      throw Exception('TimezoneService not initialized. Call initialize() first.');
    }
    final location = tz.getLocation(timezoneName);
    return tz.TZDateTime.from(dateTime, location);
  }

  /// Create TZDateTime for specific date and time in local timezone
  tz.TZDateTime createLocalDateTime({
    required int year,
    required int month,
    required int day,
    int hour = 0,
    int minute = 0,
    int second = 0,
  }) {
    if (!_isInitialized) {
      throw Exception('TimezoneService not initialized. Call initialize() first.');
    }
    return tz.TZDateTime(tz.local, year, month, day, hour, minute, second);
  }

  /// Get all available timezone names
  List<String> getAllTimezoneNames() {
    if (!_isInitialized) {
      throw Exception('TimezoneService not initialized. Call initialize() first.');
    }
    return tz.timeZoneDatabase.locations.keys.toList();
  }

  /// Get timezone offset for a specific location
  Duration getTimezoneOffset(String timezoneName) {
    if (!_isInitialized) {
      throw Exception('TimezoneService not initialized. Call initialize() first.');
    }
    final location = tz.getLocation(timezoneName);
    final now = tz.TZDateTime.now(location);
    return Duration(milliseconds: now.timeZoneOffset.inMilliseconds);
  }

  /// Get device timezone information (includes localized name on supported platforms)
  Future<TimezoneInfo> getDeviceTimezoneInfo() async {
    return await FlutterTimezone.getLocalTimezone();
  }

  /// Get device timezone identifier string
  Future<String> getDeviceTimezone() async {
    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    return timezoneInfo.identifier;
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
}
