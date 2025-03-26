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
                                      bgImage: "axis_overview.png",
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
                                      bgImage: "axis_options_itm.png",
                                      pageDescription: "",
                                    )));
                      },
                      child: Text(
                        "Options tab seciont 1",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.axisOption,
                                      bgImage: "axis_options.png",
                                      pageDescription: "",
                                    )));
                      },
                      child: Text(
                        "Options tab section 2",
                        textAlign: TextAlign.center,
                      )),

                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.axisTechnical,
                                      bgImage: "axis_technicals.png",
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
                                      pageId: PageId.axisScanners,
                                      bgImage: "axis_scanners.png",
                                      pageDescription: "",
                                    )));
                      },
                      child: Text(
                        "Screeners tab",
                        textAlign: TextAlign.center,
                      )),

                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.axisWatchlist,
                                      bgImage: "axis_watchlist.png",
                                      pageDescription: "",
                                    )));
                      },
                      child: Text(
                        "Watchlist tab",
                        textAlign: TextAlign.center,
                      )),
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
