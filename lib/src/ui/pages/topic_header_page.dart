import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/expansion_data.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flow_controller.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flow_dropdown.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flows_list.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class TopicHeaderWidget extends StatefulWidget {
  final TopicUserModel topic;
  final VoidCallback onBack;
  final ValueChanged<ExpansionData> onExpandChanged;

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
  int currentFlowId = 1;

  @override
  void initState() {
    super.initState();
    currentFlowId = widget.topic.startFlow;
    FlowController().registerCallback((highlightNextFlow) {
      setState(() {
        isExpanded = true;
      });
      widget.onExpandChanged(ExpansionData(isExpanded, currentFlowId));
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
            onEnd: () {
              if (!isExpanded) {
                widget.onExpandChanged(
                    ExpansionData(isExpanded, widget.topic.startFlow));
              }
            },
            child: isExpanded
                ? FlowsList(
                    flowModel: TopicFlowModel(
                      topicId: widget.topic.topicId,
                      userFlowsList: [],
                    ),
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
              ExpansionData(isExpanded, widget.topic.startFlow));
        }
      },
      child: Container(
        height: 10,
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.dropdownShade1, colors.dropdownShade2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 1],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: isExpanded
            ? Transform.rotate(
                angle: 3.1416,
                child: Image.asset(
                  "packages/tradeable_flutter_sdk/lib/assets/images/arrow_down.png",
                ),
              )
            : Image.asset(
                "packages/tradeable_flutter_sdk/lib/assets/images/arrow_down.png",
              ),
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
              decoration: BoxDecoration(
                color: colors.listItemTextColor1,
                borderRadius: BorderRadius.circular(4),
              ),
              height: 20,
              width: 20,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [colors.primary, colors.darkShade1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Transform.rotate(
                  angle: 3.1416,
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
          Spacer(),
          Text(widget.topic.name,
              style: textStyles.mediumBold.copyWith(
                fontSize: 18,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [colors.primary, colors.darkShade1],
                  ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
              )),
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
