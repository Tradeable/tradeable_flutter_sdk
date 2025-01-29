import 'package:example/pages/sahi/sahi_app_page.dart';
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
                                      pageId: PageId.allModule,
                                      pageDescription:
                                          "This is \nSahi Education page",
                                    )));
                      },
                      child: Text(
                        "Sahi Education Page(All Trade:able sample modules)",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.overview,
                                      pageDescription:
                                          "Sahi page with candle chart and user is a rookie",
                                    )));
                      },
                      child: Text(
                        "Sahi candle chart pages",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.optionChain,
                                      pageDescription: "Sahi's Option page",
                                    )));
                      },
                      child: Text(
                        "Sahi Option Chain page",
                        textAlign: TextAlign.center,
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SahiAppPage(
                                      pageId: PageId.technicals,
                                      pageDescription:
                                          "Sahi instrument page and user might have to undertand techincals",
                                    )));
                      },
                      child: Text(
                        "Sahi Instrument page",
                        textAlign: TextAlign.center,
                      )),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => SahiAppPage(
                  //                     pageId: PageId.events,
                  //                     pageDescription:
                  //                         "Sahi page with news etc...",
                  //                   )));
                  //     },
                  //     child: Text(
                  //       "Sahi News page",
                  //       textAlign: TextAlign.center,
                  //     )),
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
