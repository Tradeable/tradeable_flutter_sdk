import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/axis_dashboard/courses_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/axis_dashboard/overall_progress.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class AxisDashboard extends StatefulWidget {
  final EdgeInsets padding;
  final DateTime? referenceDate;
  const AxisDashboard(
      {super.key, this.padding = const EdgeInsets.all(12), this.referenceDate});

  @override
  State<AxisDashboard> createState() => _AxisDashboardState();
}

class _AxisDashboardState extends State<AxisDashboard> {
  List<CoursesModel>? courses;
  ProgressModel? model;
  OverallProgressModel? selectedProgress;
  late DateTime referenceDate;

  @override
  void initState() {
    super.initState();
    if (widget.referenceDate != null) {
      referenceDate = widget.referenceDate!;
    } else {
      referenceDate = DateTime(2023, 12, 1);
    }
    fetchData();
  }

  Future<void> fetchData() async {
    final modules = await API().getModules();
    final progress = await API().getUserProgress();

    OverallProgressModel? pickedProgress;
    List<CoursesModel> updatedCourses = List.from(modules);

    if (progress.overall.isEmpty && modules.isNotEmpty) {
      final picked = modules.first;
      pickedProgress = OverallProgressModel(
        id: picked.id,
        name: picked.name,
        description: picked.description,
        logo: picked.logo,
        lastActivityAt: DateTime.now(),
        progress: picked.progress,
      );
      updatedCourses.removeAt(0);
    }

    setState(() {
      model = progress;
      selectedProgress = pickedProgress;
      updatedCourses = updatedCourses.where((course) {
        return course.createdAt.isAfter(referenceDate);
      }).toList();
      updatedCourses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      courses = updatedCourses;
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedPercent =
        model != null ? model!.summary.completed / model!.summary.total : 0;

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LearnDashboard()),
            );
          },
          child: Padding(
            padding: EdgeInsets.only(left: widget.padding.left),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Learn Dashboard",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_right_sharp, size: 20)
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(completedPercent > 0
                          ? "Your space to track and manage your learning progress."
                          : "Start your learning journey")
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Image.asset(
                  "packages/tradeable_flutter_sdk/lib/assets/images/learn_dashboard_image.png",
                  height: 72,
                  width: 90,
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (model != null)
          Padding(
            padding: widget.padding,
            child: OverallProgress(
              progressModel: model!,
              coursesModel: selectedProgress ??
                  (model!.overall.isNotEmpty ? model!.overall.first : null),
            ),
          ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: widget.padding.left),
          child: CoursesList(courses: courses),
        )
      ],
    );
  }
}
