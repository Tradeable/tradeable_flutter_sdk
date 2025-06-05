import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/enums/page_types.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/models/user_widgets_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/learn_dashboard.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_details_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/module_card.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/module_card_shimmer.dart';

class ModuleListPage extends StatefulWidget {
  final VoidCallback onClose;
  final PageId? pageId;

  const ModuleListPage({
    super.key,
    required this.onClose,
    required this.pageId,
  });

  @override
  State<ModuleListPage> createState() => _ModuleListPageState();
}

class _ModuleListPageState extends State<ModuleListPage> {
  bool _showShimmer = true;
  List<WidgetsModel>? widgets;
  List<TopicUserModel>? topicUserModel;

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  void fetchTopics() async {
    await API().fetchTopicByTagId(widget.pageId?.topicTagId ?? 3).then((data) {
      setState(() {
        topicUserModel = data
            .map((e) => TopicUserModel(
                topicId: e.id,
                name: e.name,
                description: e.description,
                logo: e.logo,
                progress: e.progress,
                startFlow: e.startFlow,
                topicTagId: widget.pageId?.topicTagId ?? 3))
            .toList();
        _showShimmer = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: widget.onClose,
                child: const Icon(Icons.close_rounded),
              ),
            ),
            const Text(
              "What do you want to learn about today?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _showShimmer
                  ? ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: ModuleCardShimmer(),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: topicUserModel?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: ModuleCard(
                            moduleModel: topicUserModel![index],
                            onClick: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TopicDetailPage(
                                      topic: topicUserModel![index])));
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LearnDashboard()));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffF9F9F9),
                    border: Border.all(color: const Color(0xffE2E2E2))),
                child: const Center(
                  child: Text("Go to Learn Dashboard",
                      style: TextStyle(
                          color: Color(0xff97144D),
                          fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
