import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
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
    super.initState();
    flows = widget.flowModel.userFlowsList;
    if (flows == null || flows!.isEmpty) {
      getTopicById();
    } else {
      isLoading = false;
      segregrateFlows(flows!);
    }
  }

  void getTopicById() async {
    final val = await API()
        .fetchTopicById(widget.flowModel.topicId, widget.flowModel.topicTagId);
    final fetchedFlows = (val.flows
            ?.map((e) => TopicFlowsListModel(
                  name: e.name ?? "",
                  flowId: e.id,
                  isCompleted: e.isCompleted,
                  logo: e.logo,
                  category: e.category ?? "",
                ))
            .toList()) ??
        [];

    setState(() {
      flows = fetchedFlows;
      isLoading = false;
      segregrateFlows(fetchedFlows);
    });
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

    return SingleChildScrollView(
      child: Column(
        children: [
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: colors.progressIndColor1,
                    backgroundColor: colors.progressIndColor2,
                  ),
                )
              : segregratedFlows.isEmpty
                  ? Text("No data found")
                  : Column(
                      children: [
                        const SizedBox(height: 24),
                        ...segregratedFlows.asMap().entries.map((entry) {
                          final index = entry.key;
                          final flow = entry.value;
                          final isLast = index == segregratedFlows.length - 1;
                          return _buildHorizontalList(flow, isLast);
                        }),
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Image.asset(
                            "packages/tradeable_flutter_sdk/lib/assets/images/flow_banner.png",
                          ),
                        )
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(CategorisedFlow flow, bool isLast) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(flow.category.capitalize(),
              style: textStyles.smallBold.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          _buildScrollableList(flow.flowsList),
          if (!isLast) ...[
            const SizedBox(height: 24),
            Divider(color: colors.darkShade2),
            const SizedBox(height: 24),
          ]
        ],
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

        return SizedBox(
          height: 100,
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

    return ListView.separated(
      controller: controller,
      scrollDirection: Axis.horizontal,
      itemCount: flowsList.length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 100,
          child: MaterialButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              widget.onFlowSelected(flowsList[index].flowId);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (flowsList[index].logo.type == 'image/png')
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: colors.cardColorSecondary),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(6),
                    child: Image.network(flowsList[index].logo.url),
                  ),
                const SizedBox(height: 10),
                Expanded(
                  child: AutoSizeText(
                    flowsList[index].name ?? "",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    maxFontSize: 14,
                    minFontSize: 8,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          width: 10,
        );
      },
    );
  }
}
