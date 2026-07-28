import 'package:app_links/app_links.dart';
import 'package:example/pages/page_list.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';
import 'dart:async';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TFS().initialize(
    baseUrl: "",
    navigatorKey: navigatorKey,
    theme: WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark
        ? AppTheme.darkTheme()
        : AppTheme.lightTheme(),
    onEvent: (String eventName, Map<String, dynamic>? data) {
      // print("Event triggered : $eventName with data: $data");
    },
    onTokenExpiration: () async {
      // TFS().registerApp(
      //     authorization: "",
      //     portalToken: "",
      //     appId: "",
      //     clientId: "",
      //     publicKey: "");
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

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        TFS().handleDeepLink(uri);
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
      theme: TFS().themeData,
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const PageList(),
      },
    );
  }
}
