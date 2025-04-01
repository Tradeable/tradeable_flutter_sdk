import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

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
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

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
                  ? [colors.containerShade1, colors.containerShade2]
                  : [
                      colors.cardColorSecondary.withOpacity(0.8),
                      colors.cardColorSecondary.withOpacity(0.8)
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
