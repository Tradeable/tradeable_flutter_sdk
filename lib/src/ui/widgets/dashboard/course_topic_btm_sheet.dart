import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/courses_list_screen.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/topic_progress_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';

class CourseTopicsBottomSheet extends StatefulWidget {
  final int courseId;

  const CourseTopicsBottomSheet({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseTopicsBottomSheet> createState() =>
      _CourseTopicsBottomSheetState();
}

class _CourseTopicsBottomSheetState extends State<CourseTopicsBottomSheet> {
  CoursesModel? coursesModel;

  @override
  void initState() {
    super.initState();
    _fetchCourseData();
  }

  Future<void> _fetchCourseData() async {
    final val = await KagrApi().getTopicsInCourse(widget.courseId);
    setState(() {
      coursesModel = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: colors.iconColor),
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close,
                      color: colors.cardBasicBackground, size: 20)),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: coursesModel != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOPICS IN",
                            style: textStyles.smallNormal
                                .copyWith(color: colors.textColorSecondary),
                          ),
                          Text(coursesModel!.name,
                              style: textStyles.mediumBold),
                          const SizedBox(height: 20),
                          TopicProgressList(
                              courseId: widget.courseId,
                              topics: coursesModel!.topics ?? []),
                          Spacer(),
                          ButtonWidget(
                              color: colors.primary,
                              btnContent: "View more",
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CoursesListScreen(courses: [])));
                              })
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          )
        ],
      ),
    );
  }
}
