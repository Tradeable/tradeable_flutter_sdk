import 'package:axis_demo/pages/sahi/sahi_app_page.dart';
import 'package:flutter/material.dart';
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
              colors: [Colors.white, Colors.white]),
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
                                      pageId: PageId.axisOverview,
                                      pageDescription: "",
                                      bgImage: "market_depth.jpg",
                                    )));
                      },
                      child: Text(
                        "Overview tab",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.axisOption,
                                      bgImage: "option_page.jpg",
                                      pageDescription: "",
                                    )));
                      },
                      child: Text(
                        "Options tab",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.axisTechnical,
                                      bgImage: "instrument_page.jpg",
                                      pageDescription: "",
                                    )));
                      },
                      child: Text(
                        "Technical tab",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.trends,
                                      bgImage: "market_depth.png",
                                      pageDescription: "",
                                    )));
                      },
                      child: Text(
                        "Axis Market Depth Screen",
                        textAlign: TextAlign.center,
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => OptionStrategyContainer(
                  //                 spotPrice: 23245,
                  //                 spotPriceDayDelta: 17.70,
                  //                 spotPriceDayDeltaPer: 0.07,
                  //                 onExecute: () {},
                  //                 legs: [
                  //                   OptionLeg(
                  //                     symbol: "NIFTY",
                  //                     strike: 23250,
                  //                     type: PositionType.buy,
                  //                     optionType: OptionType.call,
                  //                     expiry:
                  //                         DateTime.parse("2025-02-06 15:30:00"),
                  //                     quantity: 25,
                  //                     premium: 362,
                  //                   ),
                  //                   OptionLeg(
                  //                     symbol: "NIFTY",
                  //                     strike: 23250,
                  //                     type: PositionType.buy,
                  //                     optionType: OptionType.put,
                  //                     expiry:
                  //                         DateTime.parse("2025-02-06 15:30:00"),
                  //                     quantity: 25,
                  //                     premium: 310,
                  //                   )
                  //                 ],
                  //               )));
                  //     },
                  //     child: const Text("Options Strategy")),
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
