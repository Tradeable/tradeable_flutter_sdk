import 'package:flutter/material.dart';

class FlowsList extends StatefulWidget {
  const FlowsList({super.key});

  @override
  State<StatefulWidget> createState() => _FlowsList();
}

class _FlowsList extends State<FlowsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Color(0xff313030),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 4, spreadRadius: 0.2)
        ],
      ),
      child: Column(
        children: [
          _buildHorizontalList("Education corner"),
          _buildHorizontalList("Analysis"),
          _buildHorizontalList("Practice / Scenario"),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Color(0xff1D1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTitle(title),
          _buildScrollableList(),
        ],
      ),
    );
  }

  Widget _buildListTitle(String title) {
    return Center(
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xff333131),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableList() {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.all(8),
      height: 140,
      child: RawScrollbar(
        controller: scrollController,
        thumbVisibility: true,
        thickness: 3,
        radius: Radius.circular(5),
        thumbColor: Color(0xff5D5C5C),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Color(0xff303030),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(Icons.circle, color: Colors.grey, size: 30),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
