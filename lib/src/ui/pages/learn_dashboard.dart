import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/courses_horizontal_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/custom_linear_progress_indicator.dart';
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

    return Scaffold(
      appBar: AppBarWidget(title: "Learn Dashboard"),
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
              CustomLinearProgressIndicator(title: 'Overall Progress'),
              const SizedBox(height: 20),
              CoursesHorizontalList(),
              const SizedBox(height: 20),
              // WebinarsList()
            ],
          ),
        ),
      ),
    );
  }
}
