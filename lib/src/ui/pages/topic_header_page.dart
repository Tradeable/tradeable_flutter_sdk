import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/expansion_data.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flow_controller.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flow_dropdown.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flows_list.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class TopicHeaderWidget extends StatefulWidget {
  final TopicUserModel topic;
  final VoidCallback onBack;
  final Function(ExpansionData) onExpandChanged;

  const TopicHeaderWidget({
    super.key,
    required this.topic,
    required this.onBack,
    required this.onExpandChanged,
  });

  @override
  State<TopicHeaderWidget> createState() => _TopicHeaderWidgetState();
}

class _TopicHeaderWidgetState extends State<TopicHeaderWidget> {
  bool isExpanded = false;
  int? currentFlowId;
  List<TopicFlowsListModel> flows = [];

  @override
  void initState() {
    super.initState();
    if (widget.topic.startFlow != null) {
      currentFlowId = widget.topic.startFlow!;
    }
    getFlows();
  }

  void getFlows() async {
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

        FlowController().registerCallback((highlightNextFlow) {
          setState(() {
            isExpanded = true;
          });
          widget.onExpandChanged(ExpansionData(isExpanded, currentFlowId!));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlowDropdownHolder(
      toggleIcon: _buildToggleButton(),
      isExpanded: isExpanded,
      child: Column(
        children: [
          _buildHeader(),
          isExpanded ? const SizedBox(height: 20) : SizedBox.shrink(),
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? FlowsList(
                    flowModel: TopicFlowModel(
                        topicId: widget.topic.topicId,
                        userFlowsList: flows,
                        topicTagId: widget.topic.topicTagId),
                    onFlowSelected: (flowId) {
                      setState(() {
                        setState(() {
                          isExpanded = !isExpanded;
                          currentFlowId = flowId;
                        });
                        widget
                            .onExpandChanged(ExpansionData(isExpanded, flowId));
                      });
                    },
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
        if (isExpanded) {
          widget.onExpandChanged(
              ExpansionData(isExpanded, widget.topic.startFlow!));
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 14,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: -4,
            child: isExpanded
                ? Icon(Icons.arrow_drop_up, color: Colors.white, size: 20)
                : Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.darkShade3, colors.darkShade1],
        ),
      ),
      width: double.infinity,
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              decoration: BoxDecoration(
                color: colors.buttonColor,
                borderRadius: BorderRadius.circular(4),
              ),
              margin: EdgeInsets.only(left: 10),
              height: 24,
              width: 24,
              child: Center(
                child: Icon(
                  Icons.arrow_left,
                  size: 24,
                  color: colors.borderColorPrimary,
                ),
              ),
            ),
          ),
          Spacer(),
          Text(widget.topic.name,
              style: textStyles.mediumBold
                  .copyWith(fontSize: 18, color: colors.borderColorPrimary)),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 20),
            height: 28,
            width: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  color: colors.progressIndColor1,
                  backgroundColor: colors.progressIndColor2,
                  strokeWidth: 4,
                  value: widget.topic.progress.completed! /
                      widget.topic.progress.total!,
                ),
                Text(
                  '${widget.topic.progress.completed}/${widget.topic.progress.total}',
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
