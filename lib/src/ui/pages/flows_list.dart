import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/container_layout_widget.dart';

class FlowsList extends StatefulWidget {
  final TopicFlowModel flowModel;
  final Function(int) onFlowSelected;

  const FlowsList(
      {super.key, required this.flowModel, required this.onFlowSelected});

  @override
  State<StatefulWidget> createState() => _FlowsList();
}

class _FlowsList extends State<FlowsList> {
  List<TopicFlowsListModel>? flows;
  List<CategorisedFlow> segregratedFlows = [];
  bool isLoading = true;

  @override
  void initState() {
    getTopicById();
    super.initState();
  }

  void getTopicById() async {
    await KagrApi()
        .fetchTopicById(widget.flowModel.topicId, widget.flowModel.moduleId, 1)
        .then((val) {
      setState(() {
        widget.flowModel.userFlowsList = (val.flows?.map((e) =>
                    TopicFlowsListModel(
                        flowId: e.id,
                        isCompleted: e.isCompleted,
                        logo: e.logo,
                        category: e.category ?? "")) ??
                [])
            .toList();
        flows = widget.flowModel.userFlowsList;
        isLoading = false;
      });
    });
    segregrateFlows(flows ?? []);
  }

  void segregrateFlows(List<TopicFlowsListModel> flows) {
    Map<String, List<TopicFlowsListModel>> categorisedFlows = {};
    for (TopicFlowsListModel flow in flows) {
      categorisedFlows.putIfAbsent(flow.category, () => []).add(flow);
    }

    setState(() {
      segregratedFlows = categorisedFlows.entries
          .map((entry) =>
              CategorisedFlow(category: entry.key, flowsList: entry.value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContainerLayoutWidget(
      childWidget: Column(
        children: [
          isLoading
              ? CircularProgressIndicator()
              : segregratedFlows.isEmpty
                  ? Text("No data found")
                  : Column(
                      children: [
                        ...segregratedFlows
                            .map((flow) => _buildHorizontalList(flow))
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(CategorisedFlow flow) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Color(0xff1D1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTitle(flow.category),
          _buildScrollableList(flow.flowsList),
        ],
      ),
    );
  }

  Widget _buildListTitle(String title) {
    return Center(
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: Color(0xff333131),
          boxShadow: [
            BoxShadow(
                color: Colors.black,
                blurRadius: 9,
                spreadRadius: 0.4,
                offset: Offset(3, 6))
          ],
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

  Widget _buildScrollableList(List<TopicFlowsListModel> flowsList) {
    final ScrollController scrollController = ScrollController();

    return LayoutBuilder(
      builder: (context, constraints) {
        double totalItemsWidth = flowsList.length * 100;
        bool isScrollable = totalItemsWidth > constraints.maxWidth;

        return Container(
          padding: const EdgeInsets.all(8),
          height: 140,
          child: isScrollable
              ? RawScrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 3,
                  radius: Radius.circular(5),
                  thumbColor: Color(0xff5D5C5C),
                  child: _buildListView(scrollController, flowsList),
                )
              : _buildListView(null, flowsList),
        );
      },
    );
  }

  Widget _buildListView(
      ScrollController? controller, List<TopicFlowsListModel> flowsList) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: flowsList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.onFlowSelected(flowsList[index].flowId);
            },
            child: Container(
              width: 100,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(flowsList[index].logo.url)),
                color: Color(0xff303030),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 6, bottom: 10),
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    color: const Color(0xff919191),
                    backgroundColor: const Color(0xff4A4949),
                    strokeWidth: 2,
                    value: 1,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
