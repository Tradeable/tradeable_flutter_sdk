import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/courses_list_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/courses_shimmer_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/course_item.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CoursesHorizontalList extends StatelessWidget {
  final List<CoursesModel> courses;

  const CoursesHorizontalList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    AutoSizeGroup group = AutoSizeGroup();

    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Courses", style: textStyles.mediumBold),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CoursesListPage(courses: courses)));
              },
              child: Row(
                children: [
                  Text("VIEW ALL",
                      style: textStyles.smallBold
                          .copyWith(fontSize: 12)
                          .copyWith(color: colors.viewAllTextColor)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios,
                      size: 10, color: colors.viewAllTextColor)
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        courses.isNotEmpty
            ? SizedBox(
                height: 160,
                child: ListView.builder(
                    itemCount: courses.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final cardColors = [
                        colors.courseCardColor1,
                        colors.courseCardColor2,
                        colors.courseCardColor3,
                        colors.courseCardColor4
                      ];
                      return CourseListItem(
                        model: courses[index],
                        group: group,
                        courseBgColor: cardColors[index % cardColors.length],
                      );
                    }),
              )
            : CoursesListShimmer()
      ],
    );
  }
}
