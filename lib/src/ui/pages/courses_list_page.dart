import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class CoursesListPage extends StatefulWidget {
  final List<CoursesModel> courses;
  final String? source;

  const CoursesListPage({super.key, required this.courses, this.source});

  @override
  State<StatefulWidget> createState() => _CoursesListScreen();
}

class _CoursesListScreen extends State<CoursesListPage> {
  List<CoursesModel> courses = [];
  bool isLoading = true;

  @override
  void initState() {
    // TFS().onEvent(eventName: AppEvents.viewAllCourses, data: {});
    if (widget.courses.isEmpty) {
      getModules();
    } else {
      courses = widget.courses;
      isLoading = false;
    }
    super.initState();
  }

  void getModules() async {
    await API().getModules().then((val) {
      setState(() {
        courses = val;
        isLoading = false;
      });
    });

    TFS().onEvent(eventName: "Traders_Learn_Visited", data: {
      "source": widget.source,
      "category": "Courses",
      "sub_category": "VIEW_ALL",
      "progress": "",
      "entity_id": TFS().clientId ?? ""
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
      appBar: AppBarWidget(title: "All Courses", color: colors.background),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : courses.isEmpty
                      ? Center(child: Text("No Courses Available"))
                      : ListView.separated(
                          itemCount: courses.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child:
                                Divider(color: colors.darkShade2, thickness: 1),
                          ),
                          itemBuilder: (context, index) {
                            final item = courses[index];
                            int totalPercent = ((item.progress.completed /
                                        item.progress.total) *
                                    100)
                                .ceil()
                                .toInt();
                            return InkWell(
                              onTap: () async {
                                // TFS().onEvent(
                                //     eventName: AppEvents.viewAllTopicsInCourse,
                                //     data: {
                                //       "progressPercent": totalPercent,
                                //       "courseTitle": item.name
                                //     });
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => CourseDetailsPage(
                                            model: item,
                                            source: widget.source)))
                                    .then((val) {
                                  setState(() {
                                    isLoading = true;
                                    courses = [];
                                  });
                                  getModules();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (item.logo.type == "image/png")
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.logo.url,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(),
                                        ),
                                      )
                                    else
                                      Container(
                                          width: 60,
                                          height: 60,
                                          color: colors.borderColorSecondary),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name,
                                              style: textStyles.smallBold),
                                          const SizedBox(height: 6),
                                          totalPercent > 0
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value: ((item.progress
                                                                  .completed /
                                                              item.progress
                                                                  .total)),
                                                          backgroundColor: colors
                                                              .cardColorSecondary,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  colors
                                                                      .sliderColor),
                                                          minHeight: 5,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      "${(item.progress.completed)}/${item.progress.total} ${totalPercent == 100 ? "Completed" : "Ongoing..."}",
                                                      style: textStyles
                                                          .smallNormal
                                                          .copyWith(
                                                              fontSize: 10),
                                                    )
                                                  ],
                                                )
                                              : Text(
                                                  totalPercent == 100
                                                      ? "100% Complete"
                                                      : item.description,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: totalPercent == 100
                                                      ? textStyles.smallNormal
                                                      : textStyles.smallNormal
                                                          .copyWith(
                                                              fontSize: 12,
                                                              color: colors
                                                                  .textColorSecondary),
                                                )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                        totalPercent == 0
                                            ? "BEGIN"
                                            : totalPercent == 100
                                                ? "REVISIT"
                                                : "CONTINUE",
                                        style: textStyles.smallBold.copyWith(
                                            fontSize: 12,
                                            color: colors.viewAllTextColor)),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 12,
                                        color: colors.viewAllTextColor)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
