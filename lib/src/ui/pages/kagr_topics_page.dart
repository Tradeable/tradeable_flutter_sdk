import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_details_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/button_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class KAGRTopicsPage extends StatefulWidget {
  const KAGRTopicsPage({super.key});

  @override
  State<KAGRTopicsPage> createState() => _KAGRTopicsPageState();
}

class _KAGRTopicsPageState extends State<KAGRTopicsPage> {
  List<TopicUserModel>? topicUserModel;
  int? selectedIndex;

  @override
  void initState() {
    fetchTopics();
    super.initState();
  }

  void fetchTopics() async {
    await KagrApi().fetchTopicByTagId(3).then((data) {
      setState(() {
        topicUserModel = data
            .map((e) => TopicUserModel(
                topicId: e.id,
                name: e.name,
                description: e.description,
                logo: e.logo,
                progress: e.progress,
                startFlow: e.startFlow,
                topicTagId: 3))
            .toList();
      });
    });
  }

  void _navigateToDetail(int index, TopicUserModel topic) {
    setState(() => selectedIndex = index);
    Navigator.of(context)
        .push(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, animation, __) => FadeTransition(
            opacity: animation,
            child: TopicDetailPage(topic: topic),
          ),
        ))
        .then((_) => setState(() => selectedIndex = null));
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildTopicList()),
              DoubleLayerButtonWidget(
                  onClick: () {},
                  text: "Go to Learn Dashboard",
                  isDisabled: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.drawerHeadingG1, colors.drawerHeadingG2],
        ),
      ),
      child: Center(
        child: Text(
          "What do you want to learn about today?",
          style: textStyles.mediumBold.copyWith(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildTopicList() {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return topicUserModel != null
        ? topicUserModel!.isNotEmpty
            ? ListView.builder(
                itemCount: topicUserModel!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>
                        _navigateToDetail(index, topicUserModel![index]),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? colors.itemFocusColor
                            : colors.itemUnfocusedColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          _buildTopicCard(topicUserModel![index], index.isEven),
                    ),
                  );
                },
              )
            : Text("No data found")
        : _buildShimmerEffect();
  }

  Widget _buildShimmerEffect() {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: colors.darkShade3,
          highlightColor: colors.darkShade1,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 130,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopicCard(TopicUserModel topic, bool isLeftAligned) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colors.listItemColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isLeftAligned
            ? [
                _buildImageBox(topic.logo.url),
                _buildTopicDetails(topic, isLeftAligned)
              ]
            : [
                _buildTopicDetails(topic, isLeftAligned),
                _buildImageBox(topic.logo.url)
              ],
      ),
    );
  }

  Widget _buildImageBox(String url) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      margin: const EdgeInsets.all(4),
      width: 110,
      height: 120,
      decoration: BoxDecoration(
        color: colors.cardBasicBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.network(url),
    );
  }

  Widget _buildTopicDetails(TopicUserModel topic, bool isLeftAligned) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: topic.name,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  topic.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.smallBold
                      .copyWith(fontSize: 15, color: colors.listItemTextColor1),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              topic.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyles.smallNormal
                  .copyWith(fontSize: 12, color: colors.listItemTextColor2),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: isLeftAligned
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  "COMPLETED ${topic.progress.completed}/${topic.progress.total}",
                  style: textStyles.smallNormal
                      .copyWith(fontSize: 10, color: colors.textColorSecondary),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    color: colors.progressIndColor1,
                    backgroundColor: colors.progressIndColor2,
                    strokeWidth: 2,
                    value: topic.progress.total! > 0
                        ? topic.progress.completed! / topic.progress.total!
                        : 0.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
