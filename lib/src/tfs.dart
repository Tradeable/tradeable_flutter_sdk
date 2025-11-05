import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/utils/security.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'package:tradeable_learn_widget/tlw.dart';

typedef TokenExpirationCallback = Future<void> Function();
typedef EventCallback = Function(String, Map<String, dynamic>?);

class TFS {
  late String baseUrl;
  String? _authorization;
  String? _portalToken;
  String? _appId;
  String? _clientId;
  String? _secretKey;
  String? _publicKey;
  ThemeData? themeData;
  EventCallback? _onEventCallback;
  TokenExpirationCallback? _tokenExpirationCallback;

  static final TFS _instance = TFS._internal();

  factory TFS() => _instance;

  String? get authorization => 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMSIsIm9pZCI6MiwiaWF0IjoxNzQyNDkwOTY0LCJleHAiOjk5OTk5OTk5OTl9.BbSv_2Z9JgE53bIMbFzg2MaeeCFsrza-epaay7BfEj0';
  String? get portalToken => 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMSIsIm9pZCI6MiwiaWF0IjoxNzQyNDkwOTY0LCJleHAiOjk5OTk5OTk5OTl9.BbSv_2Z9JgE53bIMbFzg2MaeeCFsrza-epaay7BfEj0';
  String? get appId => _appId;
  String? get clientId => _clientId;
  String? get publicKey => _publicKey;
  String? get secretKey => _secretKey;

  TFS._internal();

  bool get isInitialized => _portalToken != null;

  void initialize({
    required String baseUrl,
    ThemeData? theme,
    EventCallback? onEvent,
    TokenExpirationCallback? onTokenExpiration,
  }) {
    this.baseUrl = "https://dev.api.tradeable.app/demo";
    _secretKey = generateSecretKey();
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
      required String portalToken,
      required String appId,
      required String clientId,
      required String publicKey}) {
    _authorization = authorization;
    _portalToken = portalToken;
    _appId = appId;
    _clientId = clientId;
    _publicKey = publicKey;
  }

  Future<void> onTokenExpired() async {
    return _tokenExpirationCallback?.call();
  }

  onEvent({required String eventName, required Map<String, dynamic> data}) {
    return _onEventCallback?.call(eventName, data);
  }
}
