import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _biometricsKey = 'biometrics_enabled';
  static const String _lastUpdateKey = 'last_update';

  Future<void> saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
    await prefs.setString(_lastUpdateKey, DateTime.now().toString());
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  Future<String?> getLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastUpdateKey);
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricsKey, enabled);
  }

  Future<bool> isBiometricsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricsKey) ?? false;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
