import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/flows_list.dart';

class FlowsBottomSheet extends StatefulWidget {
  final TopicUserModel topic;
  final Function(int) onFlowItemClicked;
  final int completedFlowId;

  const FlowsBottomSheet(
      {super.key,
      required this.topic,
      required this.onFlowItemClicked,
      required this.completedFlowId});

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
        .fetchTopicById(widget.topic.topicId,
            topicTagId: widget.topic.topicContextType != null &&
                    widget.topic.topicContextType == TopicContextType.tag
                ? widget.topic.topicContextId
                : null,
            moduleId: widget.topic.topicContextType != null &&
                    widget.topic.topicContextType == TopicContextType.course
                ? widget.topic.topicContextId
                : null)
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
                  topicContextType: widget.topic.topicContextType,
                  topicContextId: widget.topic.topicContextId,
                ),
                onFlowSelected: (flowId) {
                  setState(() {
                    Navigator.of(context).pop();
                    currentFlowId = flowId;
                    widget.onFlowItemClicked(currentFlowId!);
                  });
                },
                completedFlowId: widget.completedFlowId,
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
