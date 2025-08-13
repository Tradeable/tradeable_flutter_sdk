import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flows_list.dart';

class FlowsBottomSheet extends StatefulWidget {
  final TopicUserModel topic;
  final Function(int) onFlowItemClicked;

  const FlowsBottomSheet(
      {super.key, required this.topic, required this.onFlowItemClicked});

  @override
  State<StatefulWidget> createState() => _FlowsBottomSheet();
}

class _FlowsBottomSheet extends State<FlowsBottomSheet> {
  int? currentFlowId;
  List<TopicFlowsListModel> flows = [];

  @override
  void initState() {
    super.initState();
    if (widget.topic.startFlow != null) {
      currentFlowId = widget.topic.startFlow!;
    }
    getTopics();
  }

  void getTopics() async {
    await API()
        .fetchTopicById(widget.topic.topicId, widget.topic.topicTagId)
        .then((val) {
      setState(() {
        flows = (val.flows?.map((e) => TopicFlowsListModel(
                    flowId: e.id,
                    isCompleted: e.isCompleted,
                    logo: e.logo,
                    name: e.name ?? "",
                    category: e.category ?? "")) ??
                [])
            .toList();

        currentFlowId ??= flows.first.flowId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: FlowsList(
                flowModel: TopicFlowModel(
                  topicId: widget.topic.topicId,
                  userFlowsList: flows,
                  topicTagId: widget.topic.topicTagId,
                ),
                onFlowSelected: (flowId) {
                  setState(() {
                    Navigator.of(context).pop();
                    currentFlowId = flowId;
                    widget.onFlowItemClicked(currentFlowId!);
                  });
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 24,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
