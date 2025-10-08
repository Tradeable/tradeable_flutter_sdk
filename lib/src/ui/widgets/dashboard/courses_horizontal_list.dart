import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/courses_list_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/courses_shimmer_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/course_item.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CoursesHorizontalList extends StatefulWidget {
  const CoursesHorizontalList({super.key});

  @override
  State<StatefulWidget> createState() => _CoursesList();
}

class _CoursesList extends State<CoursesHorizontalList> {
  List<CoursesModel> courses = [];
  AutoSizeGroup group = AutoSizeGroup();

  @override
  void initState() {
    getModules();
    super.initState();
  }

  void getModules() async {
    await API().getModules().then((val) {
      setState(() {
        courses = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Text("View all",
                      style: textStyles.smallBold
                          .copyWith(color: colors.borderColorPrimary)),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios,
                      size: 10, color: colors.borderColorPrimary)
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
                      return CourseListItem(
                        model: courses[index],
                        group: group,
                      );
                    }),
              )
            : CoursesListShimmer()
      ],
    );
  }
}
