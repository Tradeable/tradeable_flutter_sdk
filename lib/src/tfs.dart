import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/network/axis_api.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'package:tradeable_learn_widget/tlw.dart';

typedef TokenExpirationCallback = Future<void> Function();

class TFS {
  late String baseUrl;
  String? _token;
  String? _appId;
  String? _clientId;
  String? _encryptionKey;
  ThemeData? themeData;
  TokenExpirationCallback? _tokenExpirationCallback;

  static final TFS _instance = TFS._internal();

  factory TFS() => _instance;

  String? get token => _token;
  String? get appId => _appId;
  String? get clientId => _clientId;
  String? get encryptionKey => _encryptionKey;

  TFS._internal();

  bool get isInitialized => _token != null;

  void initialize({
    required String baseUrl,
    ThemeData? theme,
    TokenExpirationCallback? onTokenExpiration,
  }) {
    this.baseUrl = baseUrl;
    themeData = theme ?? AppTheme.lightTheme();
    TLW().initialize(themeData: themeData);
    StorageManager().initialize();
    getEncyptionKey();

    if (onTokenExpiration != null) {
      _tokenExpirationCallback = onTokenExpiration;
    }
  }

  void registerApp(
      {required String token,
      required String appId,
      required String clientId,
      required String encryptionKey}) {
    _token = token;
    _appId = appId;
    _clientId = clientId;
    _encryptionKey = encryptionKey;
  }

  Future<void> onTokenExpired() async {
    return _tokenExpirationCallback?.call();
  }

  Future<void> getEncyptionKey() async {
    _encryptionKey = await axisHandshake();
  }
}
