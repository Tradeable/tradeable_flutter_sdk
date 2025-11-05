import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/progress_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/custom_linear_progress_indicator.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/user_activity_screen.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class OverallProgressWidget extends StatefulWidget {
  const OverallProgressWidget({super.key});

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.borderColorSecondary)),
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
                    Text(
                        "You’re making great progress—keep going to reach your learning goals!",
                        style: textStyles.smallNormal.copyWith(fontSize: 11))
                  ],
                ),
              ),
              const SizedBox(width: 10),
              model != null
                  ? _progressCircle(
                      completedPercent, inProgressPercent, completedPercent)
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
          const SizedBox(height: 20),
          _legend(),
          const SizedBox(height: 20),
          model != null
              ? CustomLinearProgressIndicator(
                  overallProgress: model!.overall,
                  progressPercent: completedPercent)
              : Container(),
        ],
      ),
    );
  }

  Widget _progressCircle(double completedPercent, double inProgressPercent,
      double progressPercent) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: _MultiProgressPainter(
          segments: [
            _SegmentData(color: colors.alertSuccess, percent: completedPercent),
            _SegmentData(
                color: colors.alertVariable, percent: inProgressPercent),
          ],
          backgroundColor: Colors.grey.shade200,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${(progressPercent * 100).toInt()}%",
                style:
                    textStyles.mediumBold.copyWith(color: colors.sliderColor),
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem("In-progress", colors.alertVariable, inProgress),
        SizedBox(
            height: 40,
            child: VerticalDivider(
              color: colors.borderColorSecondary,
              thickness: 1,
            )),
        _legendItem("Completed", colors.alertSuccess, completed),
        SizedBox(
            height: 40,
            child: VerticalDivider(
              color: colors.borderColorSecondary,
              thickness: 1,
            )),
        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    UserActivityScreen(progressItems: model?.overall ?? [])));
          },
          child: Row(
            children: [
              Text(
                "VIEW ALL",
                style: textStyles.smallBold.copyWith(
                  fontSize: 12,
                  color: colors.sliderColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 10,
                color: colors.sliderColor,
              ),
            ],
          ),
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
            Text(value.toInt().toString(), style: textStyles.largeBold),
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

  final double strokeWidth = 8;
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
