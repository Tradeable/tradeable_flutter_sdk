import 'package:flutter/material.dart';

class FlowDropdownHolder extends StatelessWidget {
  final Widget child;
  final Widget toggleIcon;

  const FlowDropdownHolder(
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
