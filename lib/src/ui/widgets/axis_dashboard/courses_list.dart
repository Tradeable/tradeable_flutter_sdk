import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/courses_shimmer_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/course_item.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CoursesList extends StatelessWidget {
  final List<CoursesModel>? courses;

  const CoursesList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    AutoSizeGroup group = AutoSizeGroup();

    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    if (courses != null && courses!.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recently Added", style: textStyles.mediumBold),
        const SizedBox(height: 16),
        courses != null
            ? SizedBox(
                height: 160,
                child: ListView.builder(
                    clipBehavior: Clip.none,
                    itemCount: courses!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final cardColors = [
                        Color(0xffF9F1EB),
                        Color(0xffEBF0F9),
                        Color(0xffF9EBEF),
                        Color(0xffEFF9EB)
                      ];
                      return CourseListItem(
                        model: courses![index],
                        group: group,
                        courseBgColor: cardColors[index % cardColors.length],
                        showTag: true,
                      );
                    }),
              )
            : CoursesListShimmer()
      ],
    );
  }
}
