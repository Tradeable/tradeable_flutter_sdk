import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/topic_user_model.dart';
import 'package:tradeable_flutter_sdk/src/network/kagr_api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_details_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CourseDetailsScreen extends StatefulWidget {
  final CoursesModel model;

  const CourseDetailsScreen({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _CourseDetailsScreen();
}

class _CourseDetailsScreen extends State<CourseDetailsScreen> {
  CoursesModel? coursesModel;

  @override
  void initState() {
    coursesModel = widget.model;
    super.initState();
    getCourseTopicsById();
  }

  void getCourseTopicsById() async {
    final val = await KagrApi().getTopicsInCourse(widget.model.id);
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
      appBar: AppBarWidget(title: widget.model.name),
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
                    final item = coursesModel!.topics![index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TopicDetailPage(
                                topic: TopicUserModel(
                                    topicId: item.id,
                                    name: item.name,
                                    description: item.description,
                                    logo: item.logo,
                                    progress: item.progress,
                                    topicTagId: coursesModel!.id))));
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
                            Text("BEGIN",
                                style: textStyles.smallBold.copyWith(
                                    fontSize: 12,
                                    color: colors.borderColorPrimary)),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios,
                                size: 10, color: colors.borderColorPrimary)
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
}
