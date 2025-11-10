import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class OverallProgress extends StatefulWidget {
  final ProgressModel progressModel;
  final OverallProgressModel? coursesModel;

  const OverallProgress(
      {super.key, required this.progressModel, this.coursesModel});

  @override
  State<StatefulWidget> createState() => _OverallProgressIndicator();
}

class _OverallProgressIndicator extends State<OverallProgress> {
  int completed = 0;
  int inProgress = 0;
  int total = 0;
  ProgressModel? model;

  @override
  void initState() {
    getProgress();
    super.initState();
  }

  void getProgress() async {
    setState(() {
      model = widget.progressModel;
      completed = model!.summary.completed;
      inProgress = model!.summary.inProgress;
      total = model!.summary.total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedPercent = completed / total;

    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.darkShade2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Overall Progress",
                            style:
                                textStyles.mediumBold.copyWith(fontSize: 14)),
                        Spacer(),
                        Text(
                            "${(completedPercent * 100).toStringAsFixed(0)}% Complete",
                            style: textStyles.largeBold.copyWith(
                                fontSize: 16, color: colors.supportPositive))
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                        completedPercent == 0 ||
                                (model != null && model!.overall.isEmpty)
                            ? "Let's get you started"
                            : "Recent Activity",
                        style: textStyles.smallNormal.copyWith(fontSize: 14))
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          model != null
              ? model!.overall.isNotEmpty
                  ? _buildProgressItem(model!.overall[0], context)
                  : widget.coursesModel != null
                      ? _buildNotStartedCard(widget.coursesModel!, context)
                      : Container()
              : Container()
        ],
      ),
    );
  }

  Widget _buildProgressItem(OverallProgressModel item, BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    final itemProgressPercent = item.progress.total > 0
        ? (item.progress.completed / item.progress.total).clamp(0.0, 1.0)
        : 0.0;
    final accentColor = colors.dataVis1;

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
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CourseDetailsPage(courseId: item.id)),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: colors.neutral_2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
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
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CourseDetailsPage(courseId: item.id)),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: colors.neutral_2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
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
                              color: colors.borderColorPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios,
                              size: 12, color: colors.borderColorPrimary),
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
