import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/progress_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/events.dart';

class UserActivityScreen extends StatefulWidget {
  final List<OverallProgressModel> progressItems;
  final VoidCallback updateProgress;

  const UserActivityScreen({
    super.key,
    required this.progressItems,
    required this.updateProgress,
  });

  @override
  State<StatefulWidget> createState() => _UserActivityScreen();
}

class _UserActivityScreen extends State<UserActivityScreen> {
  bool isLoading = true;
  List<OverallProgressModel> progressItems = [];
  List<OverallProgressModel> inProgressItems = [];
  List<OverallProgressModel> completedItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.progressItems.isNotEmpty) {
      progressItems = widget.progressItems;
      _categorizeProgress();
      isLoading = false;
    } else {
      getProgress();
    }
  }

  void getProgress() async {
    setState(() {
      isLoading = true;
    });
    API().getUserProgress().then((va) {
      setState(() {
        progressItems = va.overall;
        _categorizeProgress();
        isLoading = false;
      });
    });
  }

  void _categorizeProgress() {
    inProgressItems = [];
    completedItems = [];
    for (final i in progressItems) {
      final percent = (i.progress.completed / i.progress.total) * 100;
      if (percent == 100) {
        completedItems.add(i);
      } else {
        inProgressItems.add(i);
      }
    }

    TFS().onEvent(eventName: AppEvents.viewAllOverallProgress, data: {
      "completed": completedItems.length,
      "inProgress": inProgressItems.length
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBarWidget(
        title: "My Activity",
        color: colors.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            renderBanner(context),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("In Progress", style: textStyles.mediumBold),
                        const SizedBox(height: 8),
                        renderItems(context, inProgressItems),
                        const SizedBox(height: 12),
                        Text("Completed", style: textStyles.mediumBold),
                        const SizedBox(height: 8),
                        renderItems(context, completedItems),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget renderBanner(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(color: colors.neutralColor),
      child: Image.asset(
        "packages/tradeable_flutter_sdk/lib/assets/images/all_courses.png",
      ),
    );
  }

  Widget renderItems(BuildContext context, List<OverallProgressModel> items) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final cardColors = [
      const Color(0xffEBF0F9),
      const Color(0xffF9F1EB),
      const Color(0xffF9EBEF),
    ];

    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final cardColor = cardColors[index % cardColors.length];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              TFS().onEvent(eventName: AppEvents.viewAllTopicsInCourse, data: {
                "courseTitle": item.name,
                "progress":
                    ((item.progress.completed / item.progress.total) * 100)
                        .toStringAsFixed(0)
              });
              await Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          CourseDetailsPage(courseId: item.id)))
                  .then((val) {
                setState(() {
                  progressItems = [];
                  isLoading = true;
                  getProgress();
                });
                widget.updateProgress();
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.logo.url,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          item.name,
                          maxFontSize: 14,
                          minFontSize: 8,
                          style: textStyles.smallBold,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${((item.progress.completed / item.progress.total) * 100).toStringAsFixed(0)}% completed",
                          style: textStyles.smallNormal.copyWith(
                            fontSize: 12,
                            color: colors.textColorSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "MORE INFO",
                          style: textStyles.smallBold.copyWith(
                            fontSize: 12,
                            color: colors.borderColorPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: colors.borderColorPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
