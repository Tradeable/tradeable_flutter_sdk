import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'package:tradeable_learn_widget/tlw.dart';

typedef TokenRefreshCallback = Future<String> Function();

typedef TokenExpirationCallback = void Function();

class TFS {
  String? _token;
  ThemeData? themeData;
  static final TFS _instance = TFS._internal();

  factory TFS() => _instance;

  TFS._internal();

  bool get isInitialized => _token != null;

  void initialize({required String token, ThemeData? theme}) {
    _token = token;
    themeData = theme ?? AppTheme.lightTheme();
    TLW().initialize(themeData: themeData);
    StorageManager().initialize();
  }
}
