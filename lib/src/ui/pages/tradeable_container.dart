import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/module_list_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/tradeable_right_side_drawer.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class TradeableContainer extends StatefulWidget {
  final Widget child;
  final double learnBtnTopPos;
  final PageId? pageId;
  final List<ModuleLabel>? modules;
  final bool isLearnBtnStatic;

  const TradeableContainer(
      {super.key,
      required this.child,
      this.learnBtnTopPos = 180,
      this.isLearnBtnStatic = true,
      this.pageId,
      this.modules});

  @override
  State<TradeableContainer> createState() => _TradeableContainerState();
}

class _TradeableContainerState extends State<TradeableContainer>
    with SingleTickerProviderStateMixin {
  late double learnBtnTopPos;
  double animationValue = 0;

  @override
  void initState() {
    super.initState();
    learnBtnTopPos = widget.learnBtnTopPos;
  }

  waitForStorageService() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      animationValue = StorageManager().isSideDrawerOpened() ? 0 : 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: [
        widget.child,
        Positioned(
          right: 0,
          top: learnBtnTopPos,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (!widget.isLearnBtnStatic) {
                setState(() {
                  learnBtnTopPos += details.delta.dy;
                });
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 245, 241, 10),
                      blurRadius: animationValue * 8,
                      spreadRadius: animationValue,
                      offset: Offset(0, 0),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        // [
                        //   Colors.red,
                        //   Colors.red
                        // ]
                        [Color(0xffed1164), Color(0xff97144d)],
                    //[Color(0xff4a4363), Color(0xff774a3d)]
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              child: MaterialButton(
                padding: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    topRight: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                ),
                onPressed: () {
                  StorageManager().setSideDrawerOpened(true).then((value) {
                    {
                      setState(() {
                        animationValue = 0;
                      });
                    }
                  });
                  // TradeableRightSideDrawer.open(
                  //     context: context,
                  //     drawerBorderRadius: 12,
                  //     body: KAGRTopicsPage());
                  TradeableRightSideDrawer.open(
                      context: context,
                      drawerBorderRadius: 12,
                      body: ModuleListPage(
                        pageId: widget.pageId,
                        pages: widget.modules,
                        onClose: () {
                          Navigator.of(context).pop();
                        },
                      ));
                },
                child: Center(
                  child: //Icon(Icons.chevron_left, color: Colors.white),
                      Image.asset(
                    "packages/tradeable_flutter_sdk/lib/assets/images/axis_learn_logo.png",
                    height: 30,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
