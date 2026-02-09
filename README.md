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
Where you have to pass authorization, authToken, token, appId, clientId & publicKey

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TFS().initialize(
    baseUrl: "", //insert backend url
    theme: AppTheme.darkTheme(),
    onEvent: (String eventName, Map<String, dynamic>? data) {
      //print("Event triggered : $eventName with data: $data");
    },
    onTokenExpiration: () async {
      // TFS().registerApp(
      //     authorization: "",
      //     portalToken: "",
      //     appId: "",
      //     clientId: "",
      //     publicKey: "");
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
    source: "",
    child: Scaffold(
      appBar: AppBar(),
      body: const SafeArea(child: Placeholder())
    )
  );
}
```
### Adding Dashboard Widget
You can access the home screen trade:able Widget by calling `AxisDashboard`:
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(),
    body: SafeArea(
      child: AxisDashboard(source : "")
    )
  );
}
```

**Optional Parameters:**
- `padding`: Custom padding for the dashboard (default: `EdgeInsets.all(12)`)
- `dateThreshold`: Number of days to filter courses (default: `100000`)
```dart
AxisDashboard(
  padding: EdgeInsets.all(16),
  dateThreshold: 30, // Shows courses from last 30 days
)
```
