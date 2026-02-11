import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/models/progress_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/axis_dashboard/recent_activity.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/recent_activity_shimmer.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/user_activity_screen.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class OverallProgressWidget extends StatefulWidget {
  final CoursesModel? coursesModel;
  final String? source;

  const OverallProgressWidget({super.key, this.coursesModel, this.source});

  @override
  State<StatefulWidget> createState() => _OverallProgressIndicator();
}

class _OverallProgressIndicator extends State<OverallProgressWidget> {
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
      model = null;
    });
    API().getUserProgress().then((va) {
      setState(() {
        model = va;
        completed = va.summary.completed;
        inProgress = va.summary.inProgress;
        total = va.summary.total;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedPercent = completed / total;
    final inProgressPercent = inProgress / total;

    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: colors.overallProgressBg,
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
                    Text("Overall Progress",
                        style: textStyles.mediumBold.copyWith(fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(
                        completedPercent == 0
                            ? "Your financial learning journey starts here —begin your first module to build smarter money skills."
                            : completedPercent > 0
                                ? "You’re making great progress—keep going to reach your learning goals!"
                                : "You did it! You’ve completed the course.Keep the momentum going by revisioning the modules",
                        style: textStyles.smallNormal.copyWith(
                            fontSize: 11, color: colors.textColorSecondary))
                  ],
                ),
              ),
              const SizedBox(width: 10),
              model != null
                  ? _progressCircle(completedPercent, inProgressPercent)
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
          const SizedBox(height: 24),
          _legend(),
          const SizedBox(height: 24),
          model != null
              ? RecentActivity(
                  overallProgress: model!.overall,
                  progressPercent: completedPercent,
                  coursesModel: widget.coursesModel,
                  updateProgress: () {
                    getProgress();
                  },
                  source: widget.source)
              : RecentActivityShimmer(),
        ],
      ),
    );
  }

  Widget _progressCircle(double completedPercent, double inProgressPercent) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return SizedBox(
      width: 54,
      height: 54,
      child: CustomPaint(
        painter: _MultiProgressPainter(
          segments: [
            _SegmentData(color: colors.alertSuccess, percent: completedPercent),
            _SegmentData(color: colors.sliderColor, percent: inProgressPercent),
          ],
          backgroundColor: Colors.grey.shade200,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(completedPercent * 100).toInt()}%",
                style: textStyles.smallBold
                    .copyWith(color: colors.overallProgressPercentageColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legend() {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendItem("In-progress", colors.sliderColor, inProgress),
              SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    color: colors.borderColorSecondary,
                    thickness: 1,
                  )),
              _legendItem("Completed", colors.alertSuccess, completed),
            ],
          ),
        ),
        (inProgress == 0 && completed == 0)
            ? Container()
            : Row(
                children: [
                  SizedBox(
                      height: 40,
                      child: VerticalDivider(
                        color: colors.borderColorSecondary,
                        thickness: 1,
                      )),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      TFS().onEvent(eventName: "Traders_Learn_Visited", data: {
                        "source": widget.source,
                        "module": "Overall Progress",
                        "category": "VIEW_ALL",
                        "progress":
                            "${((completed / total) * 100).toStringAsFixed(2)}%",
                        "entity_id": TFS().clientId ?? ""
                      });
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserActivityScreen(
                                progressItems: model?.overall ?? [],
                                updateProgress: () {
                                  getProgress();
                                },
                              )));
                      getProgress();
                    },
                    child: Row(
                      children: [
                        Text(
                          "VIEW ALL",
                          style: textStyles.smallBold.copyWith(
                            fontSize: 12,
                            color: colors.viewAllTextColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: colors.viewAllTextColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _legendItem(String label, Color color, int value) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 10, color: color),
            const SizedBox(width: 6),
            Text(value.toInt().toString(),
                style: textStyles.largeBold.copyWith(color: color)),
          ],
        ),
        Text(label, style: textStyles.smallNormal),
      ],
    );
  }
}

class _MultiProgressPainter extends CustomPainter {
  final List<_SegmentData> segments;
  final Color backgroundColor;

  _MultiProgressPainter({
    required this.segments,
    required this.backgroundColor,
  });

  final double strokeWidth = 6;
  final double gapAngle = 0.08;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rect, 0, 2 * pi, false, bgPaint);

    double startAngle = -pi / 2;
    for (final seg in segments) {
      final sweep = (2 * pi * seg.percent) - gapAngle;
      if (sweep <= 0) continue;

      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SegmentData {
  final Color color;
  final double percent;

  _SegmentData({required this.color, required this.percent});
}
