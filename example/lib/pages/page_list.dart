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
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<PageId>(
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
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LearnDashboard()),
                    );
                  },
                  child: const Text("Go to Module List Page"))
            ],
          ),
        ),
      ),
    );
  }
}
