# Tradeable Learn SDK

## Installation
Add the following dependency to your `pubspec.yaml`:
```yaml
tradeable_learn:
  git:
    url: https://github.com/Tradeable/tradeable_flutter_sdk.git
    ref: main
```

## Update
In case there is an issue run following commands one by one
```
flutter pub upgrade fin_chart
flutter pub upgrade tradeable_learn_widget
flutter pub upgrade tradeable_flutter_sdk
```

## Initialization
Add this to your main.dart file:
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TFS().initialize(
    baseUrl: "https://dev.api.tradeable.app/demo", //insert url provided by axis
    theme: AppTheme.darkTheme(),
    onTokenExpiration: () async {
      //TFS().registerApp(token: token, appId: appId, clientId: clientId)
    });
  runApp(const MyApp());
}
```

## Basic Usage
### Adding Tradeable Learn Sheet
To add a Tradeable Learn sheet to any page, wrap your widget with `TradeableLearnContainer`:
```dart
@override
Widget build(BuildContext context) {
  return TradeableLearnContainer(
    child: Scaffold(
      appBar: AppBar(),
      body: const SafeArea(child: Placeholder())
    )
  );
}
```

## Data Configuration Methods
### 1. Using PageIds
You can configure the container by passing a `pageId`:
```dart
@override
Widget build(BuildContext context) {
  return TradeableLearnContainer(
    pageId: PageId.axis,
    child: Scaffold(
      appBar: AppBar(),
      body: const SafeArea(child: Placeholder())
    )
  );
}
```

