import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/utils/security.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'package:tradeable_learn_widget/tlw.dart';

typedef TokenExpirationCallback = Future<void> Function();
typedef EventCallback = Function(String, Map<String, dynamic>?);

enum Client { tradeable, axis }

class TFS {
  late String baseUrl;
  final Client _client = Client.tradeable;
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

  String? get authorization => _authorization;
  String? get portalToken => _portalToken;
  String? get appId => _appId;
  String? get clientId => _clientId;
  String? get publicKey => _publicKey;
  String? get secretKey => _secretKey;
  Client? get client => _client;

  TFS._internal();

  bool get isInitialized => _portalToken != null;

  void initialize({
    required String baseUrl,
    ThemeData? theme,
    EventCallback? onEvent,
    TokenExpirationCallback? onTokenExpiration,
  }) {
    this.baseUrl = baseUrl;
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

  String get _currentOS {
    if (kIsWeb) {
      return "web";
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return "Android";
      case TargetPlatform.iOS:
        return "iOS";
      case TargetPlatform.macOS:
        return "macOS";
      case TargetPlatform.windows:
        return "windows";
      case TargetPlatform.linux:
        return "linux";
      case TargetPlatform.fuchsia:
        return "fuchsia";
    }
  }

  onEvent({required String eventName, required Map<String, dynamic> data}) {
    final enrichedData = Map<String, dynamic>.from(data);
    enrichedData.putIfAbsent("OS", () => _currentOS);
    return _onEventCallback?.call(eventName, enrichedData);
  }
}
