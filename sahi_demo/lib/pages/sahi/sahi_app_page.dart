import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class SahiAppPage extends StatefulWidget {
  final PageId pageId;
  final String pageDescription;
  final String? bgImage;
  const SahiAppPage(
      {super.key,
      required this.pageId,
      required this.pageDescription,
      this.bgImage = "chart_page.png"});

  @override
  State<SahiAppPage> createState() => _SahiAppPageState();
}

class _SahiAppPageState extends State<SahiAppPage> {
  @override
  void initState() {
    super.initState();
    show();
  }

  void show() async {
    await Future.delayed(Duration(milliseconds: 300), () {
      if (mounted && !StorageManager().isDrawerDialogueShown()) {
        showOpenDrawerDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TradeableContainer(
        pageId: widget.pageId,
        isLearnBtnStatic: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/${widget.bgImage}"),
              fit: BoxFit.cover,
            ),

            // gradient: LinearGradient(
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //     colors: [
            //       Color.fromARGB(255, 63, 62, 66),
            //       Color.fromARGB(255, 41, 29, 26)
            //     ] //[Color(0xffed1164), Color(0xff97144d)],
            //     ),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          // child: Center(
          //     child: Padding(
          //   padding: const EdgeInsets.all(24.0),
          //   child: Text(widget.pageDescription,
          //       style: TextStyle(
          //           fontSize: 64,
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold)),
          // )),
        ),
      ),
    );
  }
}
