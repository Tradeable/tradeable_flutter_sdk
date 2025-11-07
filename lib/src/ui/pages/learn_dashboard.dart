import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/courses_horizontal_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/overall_progress_widget.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/topic_tag_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class LearnDashboard extends StatefulWidget {
  const LearnDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _LearnDashboard();
}

class _LearnDashboard extends State<LearnDashboard> {
  final PageController _controller = PageController();
  List<String> banners = [];
  List<CoursesModel> courses = [];

  @override
  void initState() {
    getBanners();
    getModules();
    super.initState();
  }

  void getBanners() async {
    API().getBanners().then((v) {
      setState(() {
        banners = v.map((e) => e['url'].toString()).toList();
      });
    });
  }

  void getModules() async {
    await API().getModules().then((val) {
      setState(() {
        courses = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

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
                  OverallProgressWidget(
                      coursesModel: courses.isNotEmpty ? courses[0] : null),
                  const SizedBox(height: 20),
                  CoursesHorizontalList(courses: courses),
                  const SizedBox(height: 20),
                  TopicTagWidget(),
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
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 12),
      color: colors.neutralColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome!",
              style: textStyles.mediumBold.copyWith(
                  fontStyle: FontStyle.italic, color: colors.primary)),
          Text("Ready to learn the ropes? Your trading adventure begins now!",
              style: textStyles.smallNormal
                  .copyWith(color: colors.textColorSecondary)),
          const SizedBox(height: 24),
          banners.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: PageView(
                            controller: _controller,
                            children: banners.map((url) {
                              return Image.network(
                                url,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              );
                            }).toList(),
                          )),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: banners.length,
                        effect: ExpandingDotsEffect(
                            activeDotColor: colors.sliderColor,
                            dotHeight: 6,
                            dotWidth: 6,
                            spacing: 4,
                            dotColor: colors.borderColorSecondary),
                      ),
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}
