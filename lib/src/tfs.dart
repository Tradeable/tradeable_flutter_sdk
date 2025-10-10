import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'package:tradeable_learn_widget/tlw.dart';

typedef TokenExpirationCallback = Future<void> Function();
typedef EventCallback = Function(String, Map<String, dynamic>?);

class TFS {
  late String baseUrl;
  String? _authorization;
  String? _token;
  String? _appId;
  String? _clientId;
  String? _encryptionKey;
  ThemeData? themeData;
  EventCallback? _onEventCallback;
  TokenExpirationCallback? _tokenExpirationCallback;

  static final TFS _instance = TFS._internal();

  factory TFS() => _instance;

  String? get authorization => _authorization;
  String? get token => _token;
  String? get appId => _appId;
  String? get clientId => _clientId;
  String? get encryptionKey => _encryptionKey;

  TFS._internal();

  bool get isInitialized => _token != null;

  void initialize({
    required String baseUrl,
    ThemeData? theme,
    EventCallback? onEvent,
    TokenExpirationCallback? onTokenExpiration,
  }) {
    this.baseUrl = baseUrl;
    themeData = theme ?? AppTheme.lightTheme();
    TLW().initialize(themeData: themeData);

    if (onTokenExpiration != null) {
      _tokenExpirationCallback = onTokenExpiration;
    }

    if (onEvent != null) {
      _onEventCallback = onEvent;
    }
  }

  void registerApp(
      {required String authorization,
      required String token,
      required String appId,
      required String clientId,
      required String encryptionKey}) {
    _authorization = authorization;
    _token = token;
    _appId = appId;
    _clientId = clientId;
    _encryptionKey = encryptionKey;
  }

  Future<void> onTokenExpired() async {
    return _tokenExpirationCallback?.call();
  }

  onEvent({required String eventName, required Map<String, dynamic> data}) {
    return _onEventCallback?.call(eventName, data);
  }
}
