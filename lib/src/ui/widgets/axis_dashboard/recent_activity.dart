import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/models/progress_model.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_page.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/utils/events.dart';

class RecentActivity extends StatelessWidget {
  final List<OverallProgressModel> overallProgress;
  final double progressPercent;
  final CoursesModel? coursesModel;
  final VoidCallback updateProgress;

  const RecentActivity(
      {super.key,
      required this.overallProgress,
      required this.progressPercent,
      this.coursesModel,
      required this.updateProgress});

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
                      : "Let's get you started",
                  style: textStyles.smallNormal
                      .copyWith(color: colors.recentActivityText)),
              const SizedBox(height: 10),
              renderList(context)
            ],
          )
        : Container();
  }

  Widget renderList(BuildContext context) {
    final takeCount = overallProgress.isNotEmpty ? 2 : 1;
    return Column(
      children: overallProgress.isNotEmpty
          ? overallProgress.asMap().entries.take(takeCount).map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildProgressItem(item, context, index);
            }).toList()
          : coursesModel != null
              ? [
                  _buildNotStartedCard(
                    OverallProgressModel(
                      id: coursesModel!.id,
                      name: coursesModel!.name,
                      description: coursesModel!.description,
                      logo: coursesModel!.logo,
                      lastActivityAt: DateTime.now(),
                      progress: coursesModel!.progress,
                    ),
                    context,
                  )
                ]
              : [],
    );
  }

  Widget _buildProgressItem(
      OverallProgressModel item, BuildContext context, int index) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    final itemProgressPercent = item.progress.total > 0
        ? (item.progress.completed / item.progress.total).clamp(0.0, 1.0)
        : 0.0;
    final accentColor = index == 0 ? colors.dataVis1 : colors.dataVis2;

    return itemProgressPercent > 0
        ? _buildInProgressCard(
            item, context, textStyles, colors, accentColor, itemProgressPercent)
        : _buildNotStartedCard(item, context);
  }

  Widget _buildInProgressCard(
      OverallProgressModel item,
      BuildContext context,
      dynamic textStyles,
      dynamic colors,
      Color accentColor,
      double progressPercent) {
    return InkWell(
      onTap: () async {
        TFS().onEvent(eventName: AppEvents.viewAllTopicsInCourse, data: {
          "progressPercent": progressPercent,
          "courseTitle": item.name
        });
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CourseDetailsPage(courseId: item.id)));
        updateProgress();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: colors.recentActivityItemColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.recentActivityImageBgColor),
              clipBehavior: Clip.antiAlias,
              child: Image.network(item.logo.url, fit: BoxFit.cover),
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
                          "${item.progress.completed} of ${item.progress.total} completed",
                          maxFontSize: 14,
                          minFontSize: 8,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "${(progressPercent * 100).toStringAsFixed(0)}%",
                          style: textStyles.smallNormal
                              .copyWith(color: accentColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressPercent,
                      minHeight: 4,
                      backgroundColor: colors.cardColorSecondary,
                      valueColor: AlwaysStoppedAnimation(accentColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotStartedCard(OverallProgressModel item, BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return InkWell(
      onTap: () async {
        TFS().onEvent(eventName: AppEvents.viewAllTopicsInCourse, data: {
          "progressPercent": progressPercent,
          "courseTitle": item.name
        });
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CourseDetailsPage(courseId: item.id)));
        updateProgress();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: colors.recentActivityItemColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.recentActivityImageBgColor),
              clipBehavior: Clip.antiAlias,
              child: Image.network(item.logo.url, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: textStyles.smallBold),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        "0 of ${item.progress.total} completed",
                        maxFontSize: 14,
                        minFontSize: 8,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Text(
                            "BEGIN",
                            style: textStyles.smallBold.copyWith(
                              fontSize: 12,
                              color: colors.viewAllTextColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios,
                              size: 12, color: colors.viewAllTextColor),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
