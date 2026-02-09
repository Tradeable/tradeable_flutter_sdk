import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_details_page.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class TopicProgressList extends StatelessWidget {
  final int courseId;
  final List<Topic> topics;
  final String? source;

  const TopicProgressList(
      {super.key, required this.courseId, required this.topics, this.source});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return ListView.builder(
      itemCount: topics.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final topic = topics[index];
        final isCompleted = topic.progress.completed == topic.progress.total;
        final percent = (topic.progress.total == 0)
            ? 0.0
            : (topic.progress.completed) / (topic.progress.total);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CustomPaint(
                  painter: _CircleProgressPainter(
                      progress: percent,
                      isCompleted: isCompleted,
                      color: colors.courseBtmSheetBtnColor),
                  child: SizedBox(width: 25, height: 25),
                ),
                if (index != topics.length - 1)
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      width: 3,
                      height: 30,
                      color: colors.progressIndColor2)
              ],
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TopicDetailPage(
                        source: source,
                        topic: TopicUserModel(
                            topicId: topic.id,
                            name: topic.name,
                            description: topic.description,
                            logo: topic.logo,
                            progress: topic.progress,
                            topicContextType: TopicContextType.course,
                            topicContextId: courseId))));
              },
              child: Row(
                children: [
                  Text(
                    topic.name,
                    style: textStyles.mediumNormal,
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.chevron_right,
                      color: colors.courseBtmSheetBtnColor, size: 20)
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final bool isCompleted;
  final Color color;

  _CircleProgressPainter(
      {required this.progress, required this.isCompleted, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 4.0;
    final bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(center, radius, bgPaint);

    if (isCompleted) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, fillPaint);
    } else if (progress > 0) {
      final startAngle = -90 * 3.1416 / 180;
      final sweepAngle = 360 * progress * 3.1416 / 180;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
