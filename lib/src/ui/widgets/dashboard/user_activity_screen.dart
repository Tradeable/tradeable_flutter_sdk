import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/progress_model.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class UserActivityScreen extends StatelessWidget {
  final List<OverallProgressModel> progressItems;

  const UserActivityScreen({super.key, required this.progressItems});

  @override
  Widget build(BuildContext context) {
    List<OverallProgressModel> inProgressItems = [];
    List<OverallProgressModel> completedItems = [];

    for (OverallProgressModel i in progressItems) {
      if ((i.progress.completed / i.progress.total) * 100 == 100) {
        completedItems.add(i);
      } else {
        inProgressItems.add(i);
      }
    }
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("In Progress", style: textStyles.mediumBold),
                  const SizedBox(height: 8),
                  renderItems(context, inProgressItems),
                  const SizedBox(height: 12),
                  Text("Completed", style: textStyles.mediumBold),
                  const SizedBox(height: 8),
                  renderItems(context, completedItems)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renderBanner(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(color: colors.neutralColor),
        child: Image.asset(
            "packages/tradeable_flutter_sdk/lib/assets/images/all_courses.png"));
  }

  Widget renderItems(BuildContext context, List<OverallProgressModel> items) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    final cardColors = [
      Color(0xffEBF0F9),
      Color(0xffF9F1EB),
      Color(0xffF9EBEF)
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
            onTap: () {},
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
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CourseDetailsPage(courseId: item.id)));
                      },
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
