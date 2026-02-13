import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_page.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/topic_progress_widget.dart';
import 'package:tradeable_learn_widget/utils/button_widget.dart';

class CourseTopicsBottomSheet extends StatefulWidget {
  final int courseId;
  final String? source;

  const CourseTopicsBottomSheet(
      {super.key, required this.courseId, this.source});

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
    final val = await API().getTopicsInCourse(widget.courseId);
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
                  icon: Icon(Icons.close, color: colors.axisColor, size: 20)),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: coursesModel != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text("TOPICS IN",
                              style: textStyles.smallNormal
                                  .copyWith(color: colors.textColorSecondary)),
                          Text(coursesModel!.name,
                              style: textStyles.mediumBold),
                          const SizedBox(height: 20),
                          Expanded(
                            child: TopicProgressList(
                              courseName: coursesModel!.name,
                              courseId: widget.courseId,
                              topics: coursesModel!.topics ?? [],
                              source: widget.source,
                            ),
                          ),
                          SizedBox(height: 20),
                          ButtonWidget(
                            color: colors.courseBtmSheetBtnColor,
                            btnContent: "View more",
                            onTap: () {
                              // TFS().onEvent(
                              //     eventName: AppEvents.viewAllTopicsInCourse,
                              //     data: {"courseTitle": coursesModel!.name});
                              TFS().onEvent(
                                  eventName: "Traders_Learn_Visited",
                                  data: {
                                    "source": widget.source,
                                    "module": "Courses",
                                    "category": "VIEW_ALL",
                                    "progress": "",
                                    "entity_id": TFS().clientId ?? ""
                                  });
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailsPage(model: coursesModel!),
                              ));
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
