import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/utils/extensions.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';

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
    final val = await API().fetchTopicById(widget.flowModel.topicId);
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
                          final flow = entry.value;
                          return _buildHorizontalList(flow);
                        }),
                        renderBanner(),
                        const SizedBox(height: 20)
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(CategorisedFlow flow) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(flow.category.capitalize(), style: textStyles.smallBold),
          const SizedBox(height: 12),
          _buildListView(flow.category, flow.flowsList),
          const SizedBox(height: 24)
        ],
      ),
    );
  }

  Widget _buildListView(
      String categoryTitle, List<TopicFlowsListModel> flowsList) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final nameGroup = AutoSizeGroup();

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: flowsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        final item = flowsList[index];
        return MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () => widget.onFlowSelected(item.flowId),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (item.logo.type == 'image/png')
                Stack(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: colors.buttonColor,
                        border: Border.all(color: colors.cardColorSecondary),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(item.logo.url),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: ClipPath(
                        clipper: TriangleClipper(),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(4)),
                            color: colors.primary,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Transform.translate(
                              offset: const Offset(5, -3),
                              child: SvgPicture.asset(
                                categoryTitle
                                        .toLowerCase()
                                        .contains("education")
                                    ? "packages/tradeable_flutter_sdk/lib/assets/images/search_icon.svg"
                                    : "packages/tradeable_flutter_sdk/lib/assets/images/video_icon.svg",
                                height: 10,
                                width: 10,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 10),
              Expanded(
                child: AutoSizeText(
                  item.name ?? "",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  group: nameGroup,
                  maxFontSize: 14,
                  minFontSize: 10,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget renderBanner() {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xffF4EBF9),
        ),
        height: 130,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enjoyed the lesson?", style: textStyles.mediumBold),
                  Text("Put your learning into action."),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 100,
                    child: ButtonWidget(
                        color: colors.primary,
                        btnContent: "Let's go!",
                        borderRadius: BorderRadius.circular(12),
                        textStyle: textStyles.smallBold
                            .copyWith(fontSize: 12, color: Colors.white),
                        onTap: () {}),
                  )
                ],
              ),
            ),
            Image.asset(
                "packages/tradeable_flutter_sdk/lib/assets/images/banner_image.png",
                height: 126)
          ],
        ));
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
