import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/progress_model.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_page.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  final List<OverallProgressModel> overallProgress;
  final double progressPercent;

  const CustomLinearProgressIndicator(
      {super.key,
      required this.overallProgress,
      required this.progressPercent});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return overallProgress.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  progressPercent > 0
                      ? "Recent Activity"
                      : "Let’s get you started",
                  style:
                      textStyles.smallNormal.copyWith(color: colors.iconColor)),
              const SizedBox(height: 10),
              renderList(context)
            ],
          )
        : Container();
  }

  Widget renderList(BuildContext context) {
    return Column(
      children: overallProgress
          .asMap()
          .entries
          .take(progressPercent > 0 ? 2 : 1)
          .map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildProgressItem(item, context, index);
      }).toList(),
    );
  }

  Widget _buildProgressItem(
      OverallProgressModel item, BuildContext context, int index) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: colors.neutral_2, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              item.logo.url,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: textStyles.smallBold),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                          maxFontSize: 14,
                          minFontSize: 8,
                          maxLines: 1,
                          "${item.progress.completed} out of ${item.progress.total} completed"),
                    ),
                    progressPercent > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                                "${((item.progress.completed / item.progress.total) * 100).toStringAsFixed(0)}%",
                                style: textStyles.smallNormal.copyWith(
                                    color: index == 0
                                        ? colors.dataVis1
                                        : colors.dataVis2)),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CourseDetailsPage(courseId: item.id)));
                            },
                            child: Row(
                              children: [
                                Text("BEGIN",
                                    style: textStyles.smallBold.copyWith(
                                        fontSize: 12,
                                        color: colors.borderColorPrimary)),
                                Icon(Icons.arrow_forward_ios,
                                    size: 12, color: colors.borderColorPrimary)
                              ],
                            ),
                          )
                  ],
                ),
                progressPercent > 0
                    ? Column(
                        children: [
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value:
                                  item.progress.completed / item.progress.total,
                              backgroundColor: colors.cardColorSecondary,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  index == 0
                                      ? colors.dataVis1
                                      : colors.dataVis2),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
