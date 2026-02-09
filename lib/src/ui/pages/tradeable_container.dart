import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_list_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/tradeable_right_side_drawer.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class TradeableContainer extends StatefulWidget {
  final Widget child;
  final double learnBtnTopPos;
  final PageId? pageId;
  final bool isLearnBtnStatic;
  final String? source;

  const TradeableContainer(
      {super.key,
      required this.child,
      this.learnBtnTopPos = 180,
      this.isLearnBtnStatic = true,
      this.pageId,
      this.source});

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

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Theme.of(context).customColors.background,
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
                        colors: [Colors.white, Colors.white],
                        //colors: [Color(0xffed1164), Color(0xff97144d)],
                      ),
                      // border: Border.all(color: Color(0xFF97144D), width: 2),
                      border: Border(
                        left: BorderSide(color: Color(0xFF97144D), width: 2),
                        top: BorderSide(color: Color(0xFF97144D), width: 2),
                        bottom: BorderSide(color: Color(0xFF97144D), width: 2),
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
                      TradeableRightSideDrawer.open(
                          context: context,
                          drawerBorderRadius: 24,
                          drawerColor:
                              Theme.of(context).customColors.background,
                          body: widget.pageId != null
                              ? TopicListPage(
                                  tagId: widget.pageId?.topicTagId,
                                  onClose: () {
                                    Navigator.of(context).pop();
                                  },
                                  source: widget.source,
                                )
                              : Center(
                                  child: Text("Please provide Id"),
                                ));
                      TFS().onEvent(eventName: "Traders_Learn_Visited", data: {
                        "source": widget.source,
                        "entity_id": widget.pageId?.topicTagId
                      });
                    },
                    child: Center(
                      child: //Icon(Icons.chevron_left, color: Colors.white),
                          SvgPicture.asset(
                        "packages/tradeable_flutter_sdk/lib/assets/images/axis_learn_logo_dec.svg",
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
