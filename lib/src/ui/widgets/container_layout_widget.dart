import 'package:flutter/material.dart';

class ContainerLayoutWidget extends StatelessWidget {
  final Widget childWidget;

  const ContainerLayoutWidget({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Color(0xff313030),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 4, spreadRadius: 0.2)
          ],
        ),
        child: childWidget);
  }
}
