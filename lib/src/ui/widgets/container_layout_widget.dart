import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class ContainerLayoutWidget extends StatelessWidget {
  final Widget childWidget;

  const ContainerLayoutWidget({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.dropdownBgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: colors.dropdownBgColor, blurRadius: 4, spreadRadius: 0.2)
          ],
        ),
        child: childWidget);
  }
}
