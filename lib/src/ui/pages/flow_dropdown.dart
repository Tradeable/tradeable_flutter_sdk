import 'package:flutter/material.dart';

class FlowDropdownHolder extends StatefulWidget {
  final bool isExpanded;
  final Widget child;
  final Widget toggleIcon;

  const FlowDropdownHolder(
      {super.key,
      required this.isExpanded,
      required this.child,
      required this.toggleIcon});

  @override
  State<StatefulWidget> createState() => _FlowDropdownHolder();
}

class _FlowDropdownHolder extends State<FlowDropdownHolder>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.isExpanded
                  ? [
                      Color(0xff363535),
                      Color(0xff3D3D3D),
                    ]
                  : [
                      Color(0xff1D1D1D).withOpacity(0.8),
                      Color(0xff303030).withOpacity(0.8),
                    ],
            ),
          ),
          child: widget.child,
        ),
        widget.toggleIcon,
      ],
    );
  }
}
