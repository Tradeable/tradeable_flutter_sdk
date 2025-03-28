import 'package:example/pages/axis/axis_page_list.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String app = "Kagr";
  switch (app) {
    case "Kagr":
      TFS().initialize(token: "token", theme: AppTheme.darkTheme());
      break;
    case "Axis":
      TFS().initialize(token: "token", theme: AppTheme.lightTheme());
      break;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const AxisPageList(),
      },
    );
  }
}
