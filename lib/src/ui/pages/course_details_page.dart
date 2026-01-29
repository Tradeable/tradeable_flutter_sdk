import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_model.dart';
import 'package:tradeable_flutter_sdk/src/models/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_details_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/utils/events.dart';

class CourseDetailsPage extends StatefulWidget {
  final CoursesModel? model;
  final int? courseId;

  const CourseDetailsPage({super.key, this.model, this.courseId});

  @override
  State<StatefulWidget> createState() => _CourseDetailsScreen();
}

class _CourseDetailsScreen extends State<CourseDetailsPage> {
  CoursesModel? coursesModel;

  @override
  void initState() {
    super.initState();
    getCourseTopicsById();
  }

  void getCourseTopicsById() async {
    coursesModel = widget.model;
    final courseId = coursesModel != null ? coursesModel?.id : widget.courseId;
    final val = await API().getTopicsInCourse(courseId!);
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

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBarWidget(
          title: (coursesModel?.name ?? ""), color: colors.background),
      body: coursesModel != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ListView.separated(
                  itemCount: coursesModel!.topics?.length ?? 0,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    Topic item = coursesModel!.topics![index];
                    return InkWell(
                      onTap: () {
                        TFS().onEvent(eventName: AppEvents.beginTopic, data: {
                          "courseTitle": coursesModel!.name,
                          "topicTitle": item.name,
                          "progress":
                              ((item.progress.completed / item.progress.total) *
                                      100)
                                  .ceil()
                                  .toStringAsFixed(0)
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TopicDetailPage(
                                courseId: widget.courseId,
                                topic: TopicUserModel(
                                    topicId: item.id,
                                    name: item.name,
                                    description: item.description,
                                    logo: item.logo,
                                    progress: item.progress,
                                    topicContextType: TopicContextType.course,
                                    topicContextId: coursesModel!.id))));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: textStyles.mediumBold),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyles.smallNormal.copyWith(
                                        color: colors.textColorSecondary),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                item.categoryCount != null
                                    ? showIconSets(item)
                                    : Container(),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text("BEGIN",
                                        style: textStyles.smallBold.copyWith(
                                            fontSize: 12,
                                            color: colors.viewAllTextColor)),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 10,
                                        color: colors.viewAllTextColor)
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget showIconSets(Topic item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: {
        "analysis":
            "packages/tradeable_flutter_sdk/lib/assets/images/analysis.png",
        "practice":
            "packages/tradeable_flutter_sdk/lib/assets/images/practice.png",
        "education":
            "packages/tradeable_flutter_sdk/lib/assets/images/education.png",
      }.entries.where((e) => item.categoryCount!.containsKey(e.key)).map((e) {
        return Row(
          children: [
            Image.asset(e.value, width: 20, height: 20),
            Text('x${item.categoryCount![e.key]}'),
            const SizedBox(width: 10)
          ],
        );
      }).toList(),
    );
  }
}
