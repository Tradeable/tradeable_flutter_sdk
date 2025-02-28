# Tradeable Learn SDK

## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
tradeable_learn:
  git:
    url: https://github.com/Tradeable/tradeable_learn.git
    ref: main
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
    pageId: PageId.allModule,
    child: Scaffold(
      appBar: AppBar(),
      body: const SafeArea(child: Placeholder())
    )
  );
}
```

Available PageIds:

- `allModule`
- `overview`
- `optionChain`
- `technicals`
- `events`
- `other`

### 2. Using ModuleLabels

Alternatively, you can pass specific module labels:

```dart
@override
Widget build(BuildContext context) {
  return TradeableLearnContainer(
    modules: const [ModuleLabel.candlestickPatterns],
    child: Scaffold(
      appBar: AppBar(),
      body: const SafeArea(child: Placeholder())
    )
  );
}
```

Available ModuleLabels:

- `moneyness`
- `options`
- `supportAndResistance`
- `introToTA`
- `circuits`
- `candlestickPatterns`

## Option Strategy Container

To implement an Option Strategy, use the following code:

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => OptionStrategyContainer(
      spotPrice: 24662,
      spotPriceDayDelta: 17.70,
      spotPriceDayDeltaPer: 0.07,
      onExecute: () {
        // callback for execute
      },
      legs: [
        OptionLeg(
          symbol: "NIFTY",
          strike: 24750,
          type: PositionType.buy,
          optionType: OptionType.call,
          expiry: DateTime.parse("2024-12-19 15:30:00"),
          quantity: 25,
          premium: 121.8,
        ),
        OptionLeg(
          symbol: "NIFTY",
          strike: 24900,
          type: PositionType.sell,
          optionType: OptionType.call,
          expiry: DateTime.parse("2024-12-19 15:30:00"),
          quantity: 25,
          premium: 73.35,
        )
      ],
    )
  )
);
```
