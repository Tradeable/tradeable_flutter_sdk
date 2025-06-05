import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/course_topic_btm_sheet.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class CourseListItem extends StatelessWidget {
  final CoursesModel model;
  final AutoSizeGroup group;

  const CourseListItem({super.key, required this.model, required this.group});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "packages/tradeable_flutter_sdk/lib/assets/images/course_container_bg.png"),
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.borderColorSecondary)),
      child: InkWell(
        onTap: () => showBottomsheet(context, model.id),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AutoSizeText(model.name,
                        maxFontSize: 16,
                        minFontSize: 12,
                        style: textStyles.mediumBold,
                        group: group,
                        maxLines: 2),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios,
                      size: 14, color: colors.borderColorPrimary)
                ],
              ),
              const SizedBox(height: 6),
              Text("${model.progress.total} Topics | 30m")
            ],
          ),
        ),
      ),
    );
  }

  Future<CoursesModel> getCourseTopicsById(int courseId) async {
    final val = await API().getTopicsInCourse(courseId);
    return val;
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
