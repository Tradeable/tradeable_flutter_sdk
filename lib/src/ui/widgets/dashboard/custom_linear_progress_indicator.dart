import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/learn_dashboard.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  final List<ProgressItem> items;
  final String title;
  final bool alternateLayout;

  const CustomLinearProgressIndicator({
    super.key,
    required this.items,
    this.title = 'Overall Progress',
    this.alternateLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderColorSecondary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: textStyles.mediumBold),
              Spacer(),
              Text("30%", style: textStyles.mediumBold)
            ],
          ),
          const SizedBox(height: 20),
          alternateLayout
              ? _buildAlternateLayout(context)
              : _buildDefaultLayout(context),
        ],
      ),
    );
  }

  Widget _buildDefaultLayout(BuildContext context) {
    return Column(
      children:
          items.map((item) => _buildProgressItem(item, true, context)).toList(),
    );
  }

  Widget _buildAlternateLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: items
                .where((item) => items.indexOf(item) % 2 == 0)
                .map((item) => _buildProgressItem(item, false, context))
                .toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: items
                .where((item) => items.indexOf(item) % 2 != 0)
                .map((item) => _buildProgressItem(item, false, context))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem(
      ProgressItem item, bool showPercentageFirst, BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: item.progress / 100,
                backgroundColor: colors.cardColorSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(item.color),
                minHeight: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.progress.toInt()}%',
                  style: textStyles.smallBold,
                ),
                AutoSizeText(
                  item.label,
                  minFontSize: 8,
                  maxFontSize: 14,
                  maxLines: 1,
                  style: textStyles.smallNormal
                      .copyWith(color: colors.textColorSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
