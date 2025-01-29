import 'package:tradeable_flutter_sdk/src/storage/storage_service.dart';
import 'storage_keys.dart';

class StorageManager {
  final StorageService _storage;
  static final StorageManager _instance = StorageManager._internal();

  factory StorageManager() => _instance;

  StorageManager._internal() : _storage = StorageService();

  Future<void> initialize() async {
    await _storage.init();
  }

  // Cache management
  Future<void> clearCache() async {
    await _storage.clear();
  }

  Future<void> clearAll() async {
    await _storage.clear();
  }

  // Drawer state methods
  Future<void> setDrawerDialogueShown(bool shown) async {
    await _storage.setBool(StorageKeys.isDrawerDialogueShown, shown);
  }

  Future<void> setSideDrawerOpened(bool opened) async {
    await _storage.setBool(StorageKeys.isSideDrawerOpenedOnce, opened);
  }

  bool isDrawerDialogueShown() {
    return _storage.getBool(StorageKeys.isDrawerDialogueShown) ?? false;
  }

  bool isSideDrawerOpened() {
    return _storage.getBool(StorageKeys.isSideDrawerOpenedOnce) ?? false;
  }
}
