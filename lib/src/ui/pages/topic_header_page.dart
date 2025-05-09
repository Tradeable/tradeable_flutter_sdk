import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/expansion_data.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
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
    await KagrApi()
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
      child: Container(
        width: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.borderColorPrimary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: isExpanded
            ? Icon(Icons.keyboard_arrow_up, color: Colors.white)
            : Icon(Icons.keyboard_arrow_down, color: Colors.white),
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
              margin: EdgeInsets.only(left: 20),
              height: 20,
              width: 20,
              child: Icon(Icons.arrow_back_ios, size: 16),
            ),
          ),
          Spacer(),
          Text(widget.topic.name,
              style: textStyles.mediumBold.copyWith(fontSize: 18)),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 20),
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: colors.progressIndColor1,
              backgroundColor: colors.progressIndColor2,
              strokeWidth: 2,
              value: widget.topic.progress.completed! /
                  widget.topic.progress.total!,
            ),
          ),
        ],
      ),
    );
  }
}
