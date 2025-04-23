import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/courses_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/custom_linear_progress_indicator.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/progress_indicator.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/webinars_list.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class LearnDashboard extends StatefulWidget {
  const LearnDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _LearnDashboard();
}

class _LearnDashboard extends State<LearnDashboard> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    final progressItems = [
      ProgressItem(
        progress: 60,
        label: 'Technical',
        color: Colors.deepOrange,
      ),
      ProgressItem(
        progress: 82,
        label: 'Options',
        color: Colors.lime,
      ),
      ProgressItem(
        progress: 41,
        label: 'Fundamentals',
        color: Colors.pink,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Learn Dashboard",
            style: textStyles.mediumBold.copyWith(fontSize: 20)),
        titleSpacing: 0,
        actionsPadding: EdgeInsets.only(right: 10),
        actions: [Icon(Icons.account_circle_outlined)],
        leading: Icon(Icons.arrow_back),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 120,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: PageView(
                    controller: _controller,
                    children: [
                      Image.asset(
                          "packages/tradeable_flutter_sdk/lib/assets/images/dashboard_b1.png",
                          fit: BoxFit.fill),
                      Image.asset(
                          "packages/tradeable_flutter_sdk/lib/assets/images/dashboard_b1.png",
                          fit: BoxFit.fill),
                      Image.asset(
                          "packages/tradeable_flutter_sdk/lib/assets/images/dashboard_b1.png",
                          fit: BoxFit.fill),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                      activeDotColor: colors.borderColorPrimary,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                      dotColor: colors.borderColorSecondary),
                ),
              ),
              const SizedBox(height: 40),
              Text("Welcome! Deepak,",
                  style: textStyles.mediumBold
                      .copyWith(fontStyle: FontStyle.italic)),
              Text("Welcome back, Deepak. Pick up right where you left off!",
                  style: textStyles.smallNormal),
              const SizedBox(height: 20),
              // ProgressWidget(
              //   items: progressItems,
              //   overallProgress: 30,
              // ),
              CustomLinearProgressIndicator(
                title: 'Overall Progress',
                items: const [
                  ProgressItem(progress: 30, label: 'Technical', color: Colors.blue),
                  ProgressItem(progress: 60, label: 'Options', color: Colors.green),
                  ProgressItem(progress: 82, label: 'Fundamentals', color: Colors.orange),
                  ProgressItem(progress: 41, label: 'Progress', color: Colors.purple),
                ],
              ),
              const SizedBox(height: 20),
              CoursesList(),
              const SizedBox(height: 20),
              WebinarsList()
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressItem {
  final double progress;
  final String label;
  final Color color;

  const ProgressItem({
    required this.progress,
    required this.label,
    required this.color,
  });
}
