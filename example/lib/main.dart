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
    baseUrl: "",
    theme: AppTheme.darkTheme(),
    onEvent: (String eventName, Map<String, dynamic>? data) {
      //print("Event triggered : $eventName with data: $data");
    },
    onTokenExpiration: () async {
      //TFS().registerApp(token: "", appId: "", clientId: "", encryptionKey: "");
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
