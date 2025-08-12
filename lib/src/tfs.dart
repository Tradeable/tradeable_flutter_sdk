import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'package:tradeable_learn_widget/tlw.dart';

typedef TokenExpirationCallback = Future<void> Function();

class TFS {
  late String baseUrl;
  String? _token;
  String? _appId;
  String? _clientId;
  ThemeData? themeData;
  TokenExpirationCallback? _tokenExpirationCallback;

  static final TFS _instance = TFS._internal();

  factory TFS() => _instance;

  String? get token => _token;
  String? get appId => _appId;
  String? get clientId => _clientId;

  TFS._internal();

  bool get isInitialized => _token != null;

  void initialize({
    required String baseUrl,
    ThemeData? theme,
    TokenExpirationCallback? onTokenExpiration,
  }) {
    themeData = theme ?? AppTheme.lightTheme();
    TLW().initialize(themeData: themeData);
    StorageManager().initialize();

    if (onTokenExpiration != null) {
      _tokenExpirationCallback = onTokenExpiration;
    }
  }

  void registerApp(
      {required String token,
      required String appId,
      required String clientId}) {
    _token = token;
    _appId = appId;
    _clientId = clientId;
  }

  Future<void> onTokenExpired() async {
    return _tokenExpirationCallback?.call();
  }
}
