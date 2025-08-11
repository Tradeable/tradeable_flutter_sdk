import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'package:tradeable_learn_widget/tlw.dart';

typedef TokenExpirationCallback = void Function();

class TFS {
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
    ThemeData? theme,
    TokenExpirationCallback? onTokenExpiration,
  }) {
    _token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiMSIsIm9pZCI6MiwiaWF0IjoxNzQyNDkwOTY0LCJleHAiOjk5OTk5OTk5OTl9.BbSv_2Z9JgE53bIMbFzg2MaeeCFsrza-epaay7BfEj0";
    themeData = theme ?? AppTheme.lightTheme();
    TLW().initialize(themeData: themeData);
    StorageManager().initialize();

    if (onTokenExpiration != null) {
      _tokenExpirationCallback = onTokenExpiration;
    }
  }

  void setAxisParams(
      {required String token,
      required String appId,
      required String clientId}) {
    _token = token;
    _appId = appId;
    _clientId = clientId;
  }

  void onTokenExpired() {
    _tokenExpirationCallback?.call();
  }
}
