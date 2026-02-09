import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/topic_tile.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/module_card_shimmer.dart';
import 'package:tradeable_flutter_sdk/src/utils/events.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class TopicListPage extends StatefulWidget {
  final VoidCallback onClose;
  final int? tagId;
  final bool showBottomButton;
  final String? source;

  const TopicListPage(
      {super.key,
      required this.onClose,
      required this.tagId,
      this.showBottomButton = true,
      this.source});

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  bool _showShimmer = true;
  List<TopicUserModel>? topicUserModel;
  List<TopicUserModel> relatedTopics = [];

  @override
  void initState() {
    super.initState();
    if (widget.tagId != null) {
      fetchTopics(widget.tagId!).then((v) {
        fetchRelatedTopics(widget.tagId!).then((val) {
          setState(() {
            relatedTopics = {
              for (TopicUserModel topic in relatedTopics) topic.topicId: topic
            }.values.toList();
          });
        });
      });
    }
  }

  Future<void> fetchTopics(int tagId) async {
    if (widget.tagId == null) return;
    await API().fetchTopicByTagId(tagId).then((data) {
      setState(() {
        topicUserModel = data
            .map((e) => TopicUserModel(
                topicId: e.id,
                name: e.name,
                description: e.description,
                logo: e.logo,
                progress: e.progress,
                startFlow: e.startFlow,
                topicContextType: TopicContextType.tag,
                topicContextId: widget.tagId!))
            .toList();
        _showShimmer = false;
      });
    });
  }

  Future<void> fetchRelatedTopics(int tagId) async {
    for (int i = 0; i < (topicUserModel ?? []).length; i++) {
      await API()
          .fetchRelatedTopics(tagId, topicUserModel![i].topicId)
          .then((e) {
        for (int i = 0; i < e.length; i++) {
          relatedTopics.add(TopicUserModel(
              topicId: e[i].id,
              name: e[i].name,
              description: e[i].description,
              logo: e[i].logo,
              progress: e[i].progress,
              startFlow: e[i].startFlow,
              topicContextType: TopicContextType.tag,
              topicContextId: tagId));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: widget.onClose,
                    child: Icon(Icons.close_rounded,
                        color: Theme.of(context).customColors.iconColor),
                  ),
                ),
                Text(
                  "What do you want to learn about today?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showShimmer)
                    Column(
                      children: List.generate(
                          3,
                          (index) => const Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: ModuleCardShimmer(),
                              )),
                    )
                  else if (topicUserModel != null)
                    Column(
                      children: topicUserModel!.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final cardColors = [
                          Theme.of(context).customColors.topicCardColor1,
                          Theme.of(context).customColors.topicCardColor2,
                          Theme.of(context).customColors.topicCardColor3,
                          Theme.of(context).customColors.topicCardColor4
                        ];
                        final cardColor = cardColors[index % cardColors.length];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TopicTile(
                            moduleModel: item,
                            onClick: () async {
                              TFS().onEvent(
                                  eventName: AppEvents.beginTopic,
                                  data: {
                                    "comingFrom": "sideDrawer",
                                    "title": item.name,
                                    "total":
                                        "${item.progress.completed}/${item.progress.total}"
                                  });
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => TopicDetailPage(
                                          topic: item.copyWith(
                                              cardColor: cardColor),
                                          source: widget.source)))
                                  .then((val) {
                                setState(() {
                                  _showShimmer = true;
                                  topicUserModel = null;
                                  relatedTopics = [];
                                  fetchTopics(widget.tagId!);
                                });
                              });
                            },
                            cardColor: cardColor,
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                  ...relatedTopics.isEmpty
                      ? []
                      : [
                          const Text(
                            'Other related topics',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: buildOtherRelatedTopics(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          widget.showBottomButton ? buildGoToDashboardButton() : Container()
        ],
      ),
    );
  }

  Widget buildOtherRelatedTopics() {
    return Column(
      children: List.generate(
          relatedTopics.length,
          (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TopicDetailPage(
                            topic: relatedTopics[index],
                            source: widget.source)));
                  },
                  child: Row(
                    children: [
                      Text(relatedTopics[index].name,
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: Theme.of(context).customColors.iconColor)
                    ],
                  ),
                ),
              )),
    );
  }

  Widget buildGoToDashboardButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
        ),
        color: Theme.of(context).customColors.buttonColor,
        border: Border(
            top: BorderSide(
                color: Theme.of(context).customColors.buttonBorderColor)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => LearnDashboard(source: widget.source)),
          );
        },
        child: Center(
          child: Text(
            "Go to Learn Dashboard",
            style: TextStyle(
              color: Theme.of(context).customColors.goToLearnDashboardBtn,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
