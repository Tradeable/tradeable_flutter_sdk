import 'package:flutter/material.dart';

class TopicDetailPage extends StatefulWidget {
  final Map<String, dynamic> topic;

  const TopicDetailPage({super.key, required this.topic});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2A2929),
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: widget.topic["title"],
              child: CustomContainer(
                toggleIcon: _buildToggleButton(),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      _buildHeader(),
                      AnimatedSize(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: isExpanded
                            ? _buildExpandedContent()
                            : SizedBox.shrink(),
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
        height: 16,
        width: 50,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff204135), Color(0xff3D9D7F)]),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        child: Icon(
          isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: Color(0xff50F3BF),
          size: 20,
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
      widget.topic["title"],
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
        value: widget.topic["progress"],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      children: [
        SizedBox(height: 20),
        _buildHorizontalList("Education corner"),
        _buildHorizontalList("Analysis"),
        _buildHorizontalList("Practice / Scenario"),
      ],
    );
  }

  Widget _buildHorizontalList(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xff1D1D1D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTitle(title),
          _buildScrollableList(),
        ],
      ),
    );
  }

  Widget _buildListTitle(String title) {
    return Center(
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Color(0xff333131),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableList() {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 140,
      child: RawScrollbar(
        thumbVisibility: true,
        thickness: 4,
        radius: Radius.circular(5),
        thumbColor: Color(0xff5D5C5C),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Color(0xff303030),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Icon(Icons.circle, color: Colors.grey, size: 30)),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget child;
  final Widget toggleIcon;

  const CustomContainer(
      {super.key, required this.child, required this.toggleIcon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff1D1D1D).withOpacity(0.8),
                Color(0xff303030).withOpacity(0.8),
              ],
            ),
          ),
          child: child,
        ),
        toggleIcon,
      ],
    );
  }
}
