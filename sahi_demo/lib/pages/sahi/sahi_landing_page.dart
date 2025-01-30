import 'package:flutter/material.dart';
import 'package:sahi_demo/pages/sahi/sahi_app_page.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class SahiLandingPage extends StatefulWidget {
  const SahiLandingPage({super.key});

  @override
  State<SahiLandingPage> createState() => _SahiLandingPageState();
}

class _SahiLandingPageState extends State<SahiLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff4a4363), Color(0xff774a3d)]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.sahiTechnicals,
                                      pageDescription:
                                          "This is \nSahi Education page",
                                      bgImage: "instrument_page.png",
                                    )));
                      },
                      child: Text(
                        "Sahi Instrument Screen",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.sahiOptionChain,
                                      bgImage: "option_page.png",
                                      pageDescription:
                                          "Sahi page with candle chart and user is a rookie",
                                    )));
                      },
                      child: Text(
                        "Sahi option chain screen",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.sahiCandlestick,
                                      bgImage: "chart_page.png",
                                      pageDescription: "Sahi's Option page",
                                    )));
                      },
                      child: Text(
                        "Sahi Chart Screen",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.sahiMarketDepth,
                                      bgImage: "market_depth.png",
                                      pageDescription:
                                          "Sahi instrument page and user might have to undertand techincals",
                                    )));
                      },
                      child: Text(
                        "Sahi Market Depth Screen",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OptionStrategyContainer(
                                  spotPrice: 23245,
                                  spotPriceDayDelta: 17.70,
                                  spotPriceDayDeltaPer: 0.07,
                                  onExecute: () {},
                                  legs: [
                                    OptionLeg(
                                      symbol: "NIFTY",
                                      strike: 23250,
                                      type: PositionType.buy,
                                      optionType: OptionType.call,
                                      expiry:
                                          DateTime.parse("2025-02-06 15:30:00"),
                                      quantity: 25,
                                      premium: 362,
                                    ),
                                    OptionLeg(
                                      symbol: "NIFTY",
                                      strike: 23250,
                                      type: PositionType.buy,
                                      optionType: OptionType.put,
                                      expiry:
                                          DateTime.parse("2025-02-06 15:30:00"),
                                      quantity: 25,
                                      premium: 310,
                                    )
                                  ],
                                )));
                      },
                      child: const Text("Options Strategy")),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        StorageManager().clearAll();
                      },
                      child: Text("Clear cache"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
