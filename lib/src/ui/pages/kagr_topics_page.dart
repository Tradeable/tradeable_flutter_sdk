import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_details_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/button_widget.dart';

class KAGRTopicsPage extends StatefulWidget {
  const KAGRTopicsPage({super.key});

  @override
  State<KAGRTopicsPage> createState() => _KAGRTopicsPageState();
}

class _KAGRTopicsPageState extends State<KAGRTopicsPage> {
  bool isGradientChanged = false;
  ModuleUserModel? moduleUserModel;

  @override
  void initState() {
    fetchTopics();
    super.initState();
  }

  void fetchTopics() async {
    await KagrApi().fetchModuleById(1).then((data) {
      setState(() {
        moduleUserModel = ModuleUserModel(
            moduleId: data.id,
            topics: data.topics
                .map((e) => TopicUserModel(
                    topicId: e.id,
                    name: e.name,
                    description: e.description,
                    logo: e.logo,
                    progress: e.progress,
                    startFlow: e.startFlow ?? 1))
                .toList());
      });
    });
  }

  void _navigateToDetail(int moduleId, TopicUserModel topic) {
    setState(() => isGradientChanged = true);
    Navigator.of(context)
        .push(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, animation, __) => FadeTransition(
            opacity: animation,
            child: TopicDetailPage(topic: topic, moduleId: moduleId),
          ),
        ))
        .then((_) => setState(() => isGradientChanged = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2A2929),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isGradientChanged
              ? [const Color(0xff1D1D1D), const Color(0xff50F3BF)]
              : const [Color(0xff1D1D1D), Color(0xff1F1F1F), Color(0xff303030)],
        ),
      ),
      child: const Center(
        child: Text(
          "What do you want to learn about today?",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTopicList() {
    return moduleUserModel != null
        ? moduleUserModel?.topics != null
            ? ListView.builder(
                itemCount: moduleUserModel?.topics.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _navigateToDetail(moduleUserModel!.moduleId,
                        moduleUserModel!.topics[index]),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isGradientChanged
                            ? Color(0xff666666)
                            : Color(0xff1C1C1C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _buildTopicCard(
                          moduleUserModel!.topics[index], index.isEven),
                    ),
                  );
                },
              )
            : Text("No data found")
        : _buildShimmerEffect();
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
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
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff242424),
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
    return Container(
      margin: const EdgeInsets.all(4),
      width: 110,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.network(url),
    );
  }

  Widget _buildTopicDetails(TopicUserModel topic, bool isLeftAligned) {
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
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xffD3CABD)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              topic.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xffD3CABD), fontSize: 12),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: isLeftAligned
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  "COMPLETED ${topic.progress.completed}/${topic.progress.total}",
                  style:
                      const TextStyle(color: Color(0xff6F6F6F), fontSize: 10),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(
                    color: const Color(0xff919191),
                    backgroundColor: const Color(0xff4A4949),
                    strokeWidth: 2,
                    value: topic.progress.total > 0
                        ? topic.progress.completed / topic.progress.total
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
