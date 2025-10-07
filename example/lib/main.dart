import 'package:app_links/app_links.dart';
import 'package:example/pages/page_list.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'dart:async';
import 'package:example/deep_link_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TFS().initialize(
    baseUrl: "https://atom-apigee.uat.asldt.com",
    theme: AppTheme.lightTheme(),
    onEvent: (String eventName, Map<String, dynamic>? data) {
      //print("Event triggered : $eventName with data: $data");
    },
    onTokenExpiration: () async {
      //TFS().registerApp(token: "", appId: "", clientId: "", encryptionKey: "");
      TFS().registerApp(
          token: "87b357f6fd62a5ab7fcb4287172c2c09",
          appId: "ASLTRADER1",
          clientId: "100079",
          encryptionKey:
              "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApXbKe29KFkHuakMurUY/olwsjNbXDVcmYZx78oQrRU9jASeVQrW48Q+ZuU6KLEPNwGM26hBzMEs8oIgTQkaniuyChIKiSO6REQNXfxLBbjhlrpk4zuZWLcGz/bbK0rzq4MWDXSaIPd4I8dQwNMiKBqxYinuRdE37ou0HWKaLYAILMEhpQSzbjnlm0J0Nh4cJtWy+7d6ZARLRQif5kNA8sePq36aW4tF4uzgFj1qxWln9oS1IQ/4aZ4arW4sAjcppqGl15J5JwMSA6iTgCwSXHb6uplAvPacPd7w3ahSG+bDdcgLSuEWceXRpcftevMQ0UHSdzsQS9PVHaRC1peoMcQIDAQAB");
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;
  late final DeepLinkRouter _deepLinkRouter;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _deepLinkRouter = DeepLinkRouter(navigatorKey);
    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      final route = _deepLinkRouter.parseRouteFromUri(uri);
      final queryParams = uri?.queryParameters;
      if (route != null) {
        _deepLinkRouter.handleDeepLink(route, queryParams: queryParams);
      }
    });
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.light),
          useMaterial3: true),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const PageList(),
      },
    );
  }
}
