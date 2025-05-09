import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/suggestion_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/container_layout_widget.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/suggestion_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/utils/extensions.dart';

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
    if (widget.flowModel.userFlowsList.isEmpty) {
      await KagrApi().fetchTopicById(widget.flowModel.topicId, 3).then((val) {
        setState(() {
          widget.flowModel.userFlowsList = (val.flows?.map((e) =>
                      TopicFlowsListModel(
                          name: e.name ?? "",
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
    } else {
      setState(() {
        isLoading = false;
      });
      segregrateFlows(widget.flowModel.userFlowsList);
    }
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
          child: Text(title.capitalize(),
              style: textStyles.smallBold.copyWith(fontSize: 12)),
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
      child: ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: flowsList.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 100,
            height: 100,
            child: MaterialButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                widget.onFlowSelected(flowsList[index].flowId);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                decoration: BoxDecoration(
                  color: colors.darkShade3,
                  border: Border.all(color: colors.darkShade3, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (flowsList[index].logo.type == 'image/png')
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.network(flowsList[index].logo.url),
                      ),
                    Spacer(),
                    Container(
                      child: Text(
                        flowsList[index].name ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          // return InkWell(
          //   onTap: () {
          //     widget.onFlowSelected(flowsList[index].flowId);
          //   },
          //   child: Container(
          //     width: 100,
          //     margin: EdgeInsets.only(right: 10),
          //     decoration: BoxDecoration(
          //       color: colors.darkShade3,
          //       border: Border.all(color: colors.darkShade3, width: 1),
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Container(
          //         margin: const EdgeInsets.all(4),
          //         decoration: BoxDecoration(
          //           color: colors.gradientEndColor.withAlpha(21),
          //           borderRadius: BorderRadius.circular(12),
          //           border: Border.all(color: colors.secondary, width: 1),
          //         ),
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(12),
          //           child: Container(
          //             margin: const EdgeInsets.all(4),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(12),
          //               color: colors.darkShade3,
          //               boxShadow: [
          //                 BoxShadow(
          //                     color: colors.gradientEndColor.withAlpha(65),
          //                     blurRadius: 4,
          //                     spreadRadius: 4,
          //                     offset: Offset.zero,
          //                     blurStyle: BlurStyle.normal),
          //               ],
          //             ),
          //             child: Stack(
          //               children: [
          //                 if (flowsList[index].logo.type == 'image/png')
          //                   Positioned.fill(
          //                     child: Image.network(flowsList[index].logo.url),
          //                   ),
          //                 Align(
          //                   alignment: Alignment.bottomLeft,
          //                   child: Container(
          //                     margin:
          //                         const EdgeInsets.only(left: 6, bottom: 10),
          //                     height: 14,
          //                     width: 14,
          //                     child: CircularProgressIndicator(
          //                       color: colors.progressIndColor1,
          //                       backgroundColor: colors.progressIndColor2,
          //                       strokeWidth: 2,
          //                       value: flowsList[index].isCompleted ? 1 : 0,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         )),
          //   ),
          // );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 10,
          );
        },
      ),
    );
  }
}
