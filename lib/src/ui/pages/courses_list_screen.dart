import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/course_details_screen.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class CoursesListScreen extends StatefulWidget {
  final List<CoursesModel> courses;

  const CoursesListScreen({super.key, required this.courses});

  @override
  State<StatefulWidget> createState() => _CoursesListScreen();
}

class _CoursesListScreen extends State<CoursesListScreen> {
  List<CoursesModel> courses = [];
  bool isLoading = true;

  @override
  void initState() {
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
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBarWidget(title: "All Courses"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                      "packages/tradeable_flutter_sdk/lib/assets/images/all_courses.png")),
              const SizedBox(height: 20),
              Text("Welcome Deepak!", style: textStyles.mediumBold),
              const SizedBox(height: 10),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : courses.isEmpty
                      ? Center(child: Text("No Courses Available"))
                      : ListView.separated(
                          itemCount: courses.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = courses[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CourseDetailsScreen(model: item)));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Color(0xFFFCF5E8)
                                      : Color(0xFFFFE3F1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: index % 2 == 0
                                          ? Color(0xFFFCF5E8)
                                          : Color(0xFFFFE3F1)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (item.logo.type == "image/png")
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(item.logo.url,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover),
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
                                          Text(
                                            "${item.progress.total} Topics | 30m",
                                            style: textStyles.smallNormal
                                                .copyWith(
                                                    color: colors
                                                        .textColorSecondary),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text("MORE INFO",
                                        style: textStyles.smallBold.copyWith(
                                            fontSize: 12,
                                            color: colors.borderColorPrimary)),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 12,
                                        color: colors.borderColorPrimary)
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
