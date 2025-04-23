import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_screen.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/courses_list_screen.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/courses_shimmer_list.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CoursesHorizontalList extends StatefulWidget {
  const CoursesHorizontalList({super.key});

  @override
  State<StatefulWidget> createState() => _CoursesList();
}

class _CoursesList extends State<CoursesHorizontalList> {
  List<CoursesModel> courses = [];

  @override
  void initState() {
    getModules();
    super.initState();
  }

  void getModules() async {
    await KagrApi().getModules().then((val) {
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
                    builder: (context) => CoursesListScreen(courses: courses)));
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
                      return CourseListItem(model: courses[index]);
                    }),
              )
            : CoursesListShimmer()
      ],
    );
  }
}

class CourseListItem extends StatelessWidget {
  final CoursesModel model;

  const CourseListItem({super.key, required this.model});

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
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CourseDetailsScreen(model: model)));
        },
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
}
