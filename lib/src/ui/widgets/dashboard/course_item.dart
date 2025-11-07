import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/course_topic_btm_sheet.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class CourseListItem extends StatelessWidget {
  final CoursesModel model;
  final AutoSizeGroup group;
  final Color courseBgColor;
  final bool showTag;

  const CourseListItem({
    super.key,
    required this.model,
    required this.group,
    required this.courseBgColor,
    this.showTag = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: courseBgColor,
        image: DecorationImage(
          image: AssetImage(
            "packages/tradeable_flutter_sdk/lib/assets/images/course_container_bg.png",
          ),
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        onTap: () => showBottomsheet(context, model.id),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          model.name,
                          maxFontSize: 16,
                          minFontSize: 12,
                          style: textStyles.mediumBold,
                          group: group,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward_ios,
                          size: 14, color: colors.borderColorPrimary),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${model.progress.total} Topics | 30m",
                    style: textStyles.smallNormal.copyWith(
                      fontSize: 12,
                      color: colors.textColorSecondary,
                    ),
                  ),
                  const Spacer(),
                  Image.network(
                    model.logo.url,
                    width: double.infinity,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            if (showTag)
              Positioned(
                top: -6,
                right: 8,
                child: Container(
                  height: 19,
                  width: 57,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department,
                          color: colors.buttonColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'NEW',
                        style: TextStyle(
                          color: colors.buttonColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showBottomsheet(BuildContext context, int courseId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CourseTopicsBottomSheet(courseId: courseId);
      },
    );
  }
}
