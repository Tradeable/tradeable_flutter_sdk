import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_model.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flow_dropdown.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/flows_list.dart';

class TopicDetailPage extends StatefulWidget {
  final Topic topic;

  const TopicDetailPage({super.key, required this.topic});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  bool isExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2A2929),
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: widget.topic.name,
              child: FlowDropdownHolder(
                toggleIcon: _buildToggleButton(),
                isExpanded: isExpanded,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      _buildHeader(),
                      isExpanded
                          ? const SizedBox(height: 20)
                          : SizedBox.shrink(),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: isExpanded ? FlowsList() : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Container(
          height: 10,
          width: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff204135), Color(0xff3D9D7F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.2, 1]),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
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
                )),
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
          _buildBackButton(),
          Spacer(),
          _buildTitle(),
          Spacer(),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        margin: EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: Color(0xffD3CABD), borderRadius: BorderRadius.circular(4)),
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
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.topic.name,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: [Color(0xff50F3BF), Color(0xff1E1E1E)],
          ).createShader(Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: EdgeInsets.only(right: 20),
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: Color(0xff919191),
        backgroundColor: Color(0xff4A4949),
        strokeWidth: 2,
        value: widget.topic.progress.completed / widget.topic.progress.total,
      ),
    );
  }
}
