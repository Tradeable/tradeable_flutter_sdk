import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class PageList extends StatefulWidget {
  const PageList({super.key});

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  PageId? selectedPage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TradeableContainer(
      pageId: selectedPage,
      isLearnBtnStatic: false,
      learnBtnTopPos: 80,
      source: "",
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).customColors.background,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).customColors.dropdownBgColor,
                      border: Border.all(
                          color: Theme.of(context)
                              .customColors
                              .borderColorPrimary),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: DropdownButton<PageId>(
                      underline: const SizedBox.shrink(),
                      value: selectedPage,
                      items: PageId.values.map((PageId page) {
                        return DropdownMenuItem<PageId>(
                          value: page,
                          child: Text(page.name),
                        );
                      }).toList(),
                      onChanged: (PageId? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedPage = newValue;
                          });
                        }
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          selectedPage = null;
                        });
                      },
                      icon: const Icon(Icons.cancel_rounded))
                ],
              ),
              Spacer(),
              AxisDashboard(source: ""),
              // MaterialButton(
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         MaterialPageRoute(builder: (context) => LearnDashboard()),
              //       );
              //     },
              //     child: const Text("Go to Module List Page"))
            ],
          ),
        ),
      ),
    );
  }
}
