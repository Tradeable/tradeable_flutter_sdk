# Deep Linking with TFS SDK
---

## Step 1: Initialize TFS with a Navigator Key

Create a `GlobalKey<NavigatorState>` and pass it to TFS during initialization.

```dart
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  TFS().initialize(
    baseUrl: "https://your-api-url.com/",
    navigatorKey: navigatorKey, // <-- pass the key here
    theme: AppTheme.lightTheme(),
  );

  runApp(const MyApp());
}
```

Use the same key in your `MaterialApp`:

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // <-- use it here
      home: HomeScreen(),
    );
  }
}
```

---

## Step 2: Listen for Deep Links

In your app's main widget (or wherever you want to listen), subscribe to deep links and call `TFS().handleDeepLink(uri)`.

```dart
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();

    // Listen for deep links
    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        TFS().handleDeepLink(uri); 

        // NOTE: TFS only handles deeplinks that are listed below 
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
      navigatorKey: navigatorKey,
      home: HomeScreen(),
    );
  }
}
```
---

## Available Deep Link Routes

All links follow this format:
```
https://yourdomain.com/app/<route>?<params>
```

| Route | Parameters | Opens |
|-------|-----------|-------|
| `/dashboard` | none | Learn Dashboard |
| `/courses` | none | Courses List |
| `/courseById` | `courseId` (int) | Course Details |
| `/flowById` | `flowId` (int) | Flow/Widget Page |
| `/topicById` | `topicId` (int) | Topic Details |
| `/openSideDrawer` | `tagId` (int), `source` (string, optional) | Side Drawer with Topic List |
| `/userActivity` | none | User Activity Screen |

---

## Examples

```
https://yourdomain.com/app/dashboard
https://yourdomain.com/app/courses
https://yourdomain.com/app/courseById?courseId=42
https://yourdomain.com/app/flowById?flowId=10
https://yourdomain.com/app/topicById?topicId=5
https://yourdomain.com/app/openSideDrawer?tagId=5&source=homepage
https://yourdomain.com/app/userActivity
```

---