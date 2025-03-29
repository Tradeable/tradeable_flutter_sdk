import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class DoubleLayerButtonWidget extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final bool isDisabled;

  const DoubleLayerButtonWidget(
      {super.key,
      required this.onClick,
      required this.text,
      required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.darkShade1.withOpacity(0.8),
            colors.darkShade3.withOpacity(0.8),
          ],
        ),
      ),
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colors.darkShade3, colors.darkShade1],
            ),
          ),
          width: double.infinity,
          child: Center(
            child: Text(text,
                style: isDisabled
                    ? textStyles.mediumBold.copyWith(color: colors.darkShade3)
                    : textStyles.mediumBold.copyWith(
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [colors.primary, colors.darkShade1],
                          ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 400.0, 70.0)))),
          ),
        ),
      ),
    );
  }
}
