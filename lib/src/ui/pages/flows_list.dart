import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/suggestion_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/container_layout_widget.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/suggestion_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

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
    await KagrApi().fetchTopicById(widget.flowModel.topicId, 1).then((val) {
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
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return ContainerLayoutWidget(
      childWidget: Column(
        children: [
          isLoading
              ? CircularProgressIndicator(
                  color: colors.progressIndColor1,
                  backgroundColor: colors.progressIndColor2,
                )
              : segregratedFlows.isEmpty
                  ? Text("No data found")
                  : Column(
                      children: [
                        ...segregratedFlows
                            .map((flow) => _buildHorizontalList(flow)),
                        SuggestionWidget(model: SuggestionModel())
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(CategorisedFlow flow) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: colors.listBgColor,
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
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Center(
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: colors.listHeaderColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(14),
            bottomLeft: Radius.circular(14),
          ),
        ),
        child: Center(
          child:
              Text(title, style: textStyles.smallBold.copyWith(fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildScrollableList(List<TopicFlowsListModel> flowsList) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

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
                  thumbColor: colors.darkShade3,
                  child: _buildListView(scrollController, flowsList),
                )
              : _buildListView(null, flowsList),
        );
      },
    );
  }

  Widget _buildListView(
      ScrollController? controller, List<TopicFlowsListModel> flowsList) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

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
                color: colors.darkShade3,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 6, bottom: 10),
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    color: colors.progressIndColor1,
                    backgroundColor: colors.progressIndColor2,
                    strokeWidth: 2,
                    value: flowsList[index].isCompleted ? 1 : 0,
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
