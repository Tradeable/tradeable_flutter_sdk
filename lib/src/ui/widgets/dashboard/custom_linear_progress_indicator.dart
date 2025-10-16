import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/course_progress_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CustomLinearProgressIndicator extends StatefulWidget {
  final String title;
  final bool alternateLayout;

  const CustomLinearProgressIndicator({
    super.key,
    this.title = 'Overall Progress',
    this.alternateLayout = false,
  });

  @override
  State<StatefulWidget> createState() => _CustomLinearProgressIndicator();
}

class _CustomLinearProgressIndicator
    extends State<CustomLinearProgressIndicator> {
  List<CourseProgressModel> courseProgress = [];
  List<ProgressItem> progressItems = [];

  @override
  void initState() {
    getProgress();
    super.initState();
  }

  void getProgress() async {
    await API().getCourseProgress().then((val) {
      setState(() {
        courseProgress = val;
        progressItems = courseProgress
            .map((e) => ProgressItem(
                  label: e.topicName,
                  progress: e.progress.total == 0
                      ? 0
                      : ((e.progress.completed ?? 0).toDouble() /
                          (e.progress.total ?? 0).toDouble()),
                  color: Colors.blueAccent,
                ))
            .toList();
      });
    });
  }

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
              Text(widget.title, style: textStyles.mediumBold),
              // Spacer(),
              // Text("${_getOverallProgress().toStringAsFixed(2)}%",
              //     style: textStyles.mediumBold)
            ],
          ),
          const SizedBox(height: 20),
          widget.alternateLayout
              ? _buildAlternateLayout(context)
              : _buildDefaultLayout(context),
        ],
      ),
    );
  }

  // double _getOverallProgress() {
  //   if (progressItems.isEmpty) return 0;
  //   double total = progressItems.fold(0, (sum, item) => sum + item.progress);
  //   return total / progressItems.length;
  // }

  Widget _buildDefaultLayout(BuildContext context) {
    return Column(
      children: progressItems
          .map((item) => _buildProgressItem(item, true, context))
          .toList(),
    );
  }

  Widget _buildAlternateLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: progressItems
                .where((item) => progressItems.indexOf(item) % 2 == 0)
                .map((item) => _buildProgressItem(item, false, context))
                .toList(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: progressItems
                .where((item) => progressItems.indexOf(item) % 2 != 0)
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
                value: item.progress,
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
                  '${(item.progress * 100).toStringAsFixed(0)}%',
                  style: textStyles.smallBold,
                ),
                AutoSizeText(
                  item.label,
                  minFontSize: 8,
                  maxFontSize: 14,
                  maxLines: 2,
                  textAlign: TextAlign.right,
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

class ProgressItem {
  final double progress;
  final String label;
  final Color color;

  const ProgressItem({
    required this.progress,
    required this.label,
    required this.color,
  });
}
