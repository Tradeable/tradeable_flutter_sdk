import 'package:flutter/material.dart';
import 'package:sahi_demo/pages/sahi/sahi_landing_page.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TFS().initialize(token: "token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahi Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SahiLandingPage(),
      },
    );
  }
}
