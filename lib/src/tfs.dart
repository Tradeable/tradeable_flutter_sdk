import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

typedef TokenRefreshCallback = Future<String> Function();

typedef TokenExpirationCallback = void Function();

class TFS {
  String? _token;
  static final TFS _instance = TFS._internal();

  factory TFS() => _instance;

  TFS._internal();

  bool get isInitialized => _token != null;

  void initialize({
    required String token,
  }) {
    _token = token;
    StorageManager().initialize();
  }
}
