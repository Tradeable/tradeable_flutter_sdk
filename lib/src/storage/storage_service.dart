import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Low-level service for interacting with SharedPreferences
class StorageService {
  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  /// Save methods
  Future<bool> setString(String key, String value) async {
    await _ensureInitialized();
    return await _prefs.setString(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    await _ensureInitialized();
    return await _prefs.setInt(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    await _ensureInitialized();
    return await _prefs.setBool(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    await _ensureInitialized();
    return await _prefs.setStringList(key, value);
  }

  Future<bool> setObject(String key, Map<String, dynamic> value) async {
    await _ensureInitialized();
    return await _prefs.setString(key, json.encode(value));
  }

  Future<bool> setObjectList(
      String key, List<Map<String, dynamic>> value) async {
    await _ensureInitialized();
    return await _prefs.setString(key, json.encode(value));
  }

  /// Get methods
  String? getString(String key) {
    _assertInitialized();
    return _prefs.getString(key);
  }

  int? getInt(String key) {
    _assertInitialized();
    return _prefs.getInt(key);
  }

  bool? getBool(String key) {
    _assertInitialized();
    return _prefs.getBool(key);
  }

  List<String>? getStringList(String key) {
    _assertInitialized();
    return _prefs.getStringList(key);
  }

  Map<String, dynamic>? getObject(String key) {
    _assertInitialized();
    final data = _prefs.getString(key);
    if (data != null) {
      return json.decode(data) as Map<String, dynamic>;
    }
    return null;
  }

  List<Map<String, dynamic>>? getObjectList(String key) {
    _assertInitialized();
    final data = _prefs.getString(key);
    if (data != null) {
      return (json.decode(data) as List).cast<Map<String, dynamic>>().toList();
    }
    return null;
  }

  /// Utility methods
  Future<bool> remove(String key) async {
    await _ensureInitialized();
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    await _ensureInitialized();
    return await _prefs.clear();
  }

  bool containsKey(String key) {
    _assertInitialized();
    return _prefs.containsKey(key);
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  void _assertInitialized() {
    if (!_initialized) {
      throw StateError('StorageService must be initialized before use');
    }
  }
}
