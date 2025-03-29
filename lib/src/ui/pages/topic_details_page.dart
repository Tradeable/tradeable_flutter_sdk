import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/user_widgets_model.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_header_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/widget_page.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class TopicDetailPage extends StatefulWidget {
  final TopicUserModel topic;

  const TopicDetailPage({super.key, required this.topic});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<bool> isExpanded = ValueNotifier(false);
  List<WidgetsModel>? widgets;
  int flowId = 1;

  @override
  void initState() {
    flowId = widget.topic.startFlow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder<bool>(
                valueListenable: isExpanded,
                builder: (context, expanded, child) {
                  return Container(
                    margin: const EdgeInsets.only(top: 80),
                    padding: const EdgeInsets.all(10),
                    child: WidgetPage(
                        topicId: widget.topic.topicId, flowId: flowId),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TopicHeaderWidget(
                topic: widget.topic,
                onBack: () => Navigator.of(context).pop(),
                onExpandChanged: (expanded) {
                  isExpanded.value = expanded.isExpanded;
                  if (expanded.flowId != widget.topic.startFlow) {
                    setState(() {
                      flowId = expanded.flowId;
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
