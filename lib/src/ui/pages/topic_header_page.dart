import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/expansion_data.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_flow_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flow_dropdown.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flows_list.dart';

class TopicHeaderWidget extends StatefulWidget {
  final TopicUserModel topic;
  final int moduleId;
  final VoidCallback onBack;
  final ValueChanged<ExpansionData> onExpandChanged;

  const TopicHeaderWidget({
    super.key,
    required this.topic,
    required this.moduleId,
    required this.onBack,
    required this.onExpandChanged,
  });

  @override
  State<TopicHeaderWidget> createState() => _TopicHeaderWidgetState();
}

class _TopicHeaderWidgetState extends State<TopicHeaderWidget> {
  bool isExpanded = false;

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
                widget.onExpandChanged(ExpansionData(isExpanded, 1));
              }
            },
            child: isExpanded
                ? FlowsList(
                    flowModel: TopicFlowModel(
                      moduleId: widget.moduleId,
                      topicId: widget.topic.topicId,
                      userFlowsList: [],
                    ),
                    onFlowSelected: (flowId) {
                      setState(() {
                        setState(() {
                          isExpanded = !isExpanded;
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
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
        if (isExpanded) {
          widget.onExpandChanged(ExpansionData(isExpanded, 1));
        }
      },
      child: Container(
        height: 10,
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff204135), Color(0xff3D9D7F)],
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff303030), Color(0xff1D1D1D)],
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
                color: Color(0xffD3CABD),
                borderRadius: BorderRadius.circular(4),
              ),
              height: 20,
              width: 20,
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xff50F3BF), Color(0xff1E1E1E)],
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
          Text(
            widget.topic.name,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [Color(0xff50F3BF), Color(0xff1E1E1E)],
                ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 20),
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              color: Color(0xff919191),
              backgroundColor: Color(0xff4A4949),
              strokeWidth: 2,
              value:
                  widget.topic.progress.completed / widget.topic.progress.total,
            ),
          ),
        ],
      ),
    );
  }
}
