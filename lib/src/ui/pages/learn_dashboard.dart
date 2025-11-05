import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/courses_horizontal_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/overall_progress_widget.dart';
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
      backgroundColor: colors.background,
      appBar:
          AppBarWidget(title: "Learn Dashboard", color: colors.neutralColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            renderBanners(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome!",
                      style: textStyles.mediumBold.copyWith(
                          fontStyle: FontStyle.italic, color: colors.primary)),
                  const SizedBox(height: 4),
                  Text(
                      "Ready to learn the ropes? Your trading adventure begins now!",
                      style: textStyles.smallNormal
                          .copyWith(color: colors.textColorSecondary)),
                  const SizedBox(height: 24),
                  OverallProgressWidget(),
                  const SizedBox(height: 20),
                  CoursesHorizontalList(),
                  const SizedBox(height: 20),
                ],
              ),
            )
            //WebinarsList()
          ],
        ),
      ),
    );
  }

  Widget renderBanners() {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: colors.neutralColor,
      child: Column(
        children: [
          Container(
            height: 120,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
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
          const SizedBox(height: 16),
          Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                  activeDotColor: colors.sliderColor,
                  dotHeight: 6,
                  dotWidth: 6,
                  spacing: 4,
                  dotColor: colors.borderColorSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
