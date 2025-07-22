import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/models/user_widgets_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_header_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/widget_page.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class TopicDetailPage extends StatefulWidget {
  final TopicUserModel? topic;
  final int? topicId;

  const TopicDetailPage({super.key, this.topic, this.topicId});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  bool isExpanded = false;
  List<WidgetsModel>? widgets;
  int? flowId;
  TopicUserModel? _topicUserModel;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.topic != null) {
      _topicUserModel = widget.topic;
      flowId = _topicUserModel!.startFlow;
      if (flowId == null) {
        getFlows();
      }
    } else if (widget.topicId != null) {
      _fetchTopicUserModel();
    }
  }

  Future<void> _fetchTopicUserModel() async {
    setState(() {
      _loading = true;
    });
    final topic = await API().fetchTopicById(widget.topicId!, 33);
    _topicUserModel = TopicUserModel.fromTopic(topic);
    flowId = _topicUserModel!.startFlow;
    if (flowId == null) {
      await getFlows();
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> getFlows() async {
    if (_topicUserModel == null) return;
    await API()
        .fetchTopicById(_topicUserModel!.topicId, _topicUserModel!.topicTagId)
        .then((val) {
      setState(() {
        flowId ??= val.flows!.first.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    if (_topicUserModel == null || _loading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                padding: const EdgeInsets.all(10),
                child: WidgetPage(
                    topicId: _topicUserModel!.topicId, flowId: flowId ?? -1),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TopicHeaderWidget(
                topic: _topicUserModel!,
                onBack: () => Navigator.of(context).pop(),
                onExpandChanged: (expanded) {
                  isExpanded = expanded.isExpanded;
                  if (!isExpanded) {
                    setState(() {
                      flowId = expanded.flowId;
                      _topicUserModel!.startFlow = flowId;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
