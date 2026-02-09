import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tradeable_flutter_sdk/src/models/banner_model.dart';
import 'package:tradeable_flutter_sdk/src/models/courses_model.dart';
import 'package:tradeable_flutter_sdk/src/network/api.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/appbar_widget.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/courses_horizontal_list.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/overall_progress_widget.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/dashboard/topic_tag_widget.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class LearnDashboard extends StatefulWidget {
  final String? source;
  const LearnDashboard({super.key, this.source});

  @override
  State<StatefulWidget> createState() => _LearnDashboard();
}

class _LearnDashboard extends State<LearnDashboard> {
  final PageController _controller = PageController();
  List<BannerModel> banners = [];
  List<CoursesModel> courses = [];

  @override
  void initState() {
    getBanners();
    getModules();
    TFS().onEvent(
        eventName: "Traders_Learn_Dashboard",
        data: {"source": widget.source, "entity_id": TFS().clientId ?? ""});
    super.initState();
  }

  void getBanners() async {
    API().getBanners().then((v) {
      setState(() {
        banners = v;
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

  Future<void> openCtaUrl() async {
    final index = _controller.page?.round() ?? 0;
    if (index >= banners.length) return;

    final ctaUri = banners[index].ctaUri;
    if (ctaUri == null || ctaUri.isEmpty) return;

    final uri = Uri.tryParse(ctaUri);
    if (uri == null) return;

    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBarWidget(
          title: "Learn Dashboard", color: colors.learnDashboardAppbarColor),
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
                      coursesModel: courses.isNotEmpty ? courses[0] : null,
                      source: widget.source),
                  const SizedBox(height: 20),
                  CoursesHorizontalList(
                      courses: courses, source: widget.source),
                  const SizedBox(height: 20),
                  TopicTagWidget(source: widget.source),
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
      color: colors.learnDashboardAppbarColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome!",
              style: textStyles.mediumBold.copyWith(
                  fontStyle: FontStyle.italic, color: colors.headerColor)),
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
                          child: GestureDetector(
                            onTap: () {
                              // TFS().onEvent(
                              //     eventName:
                              //         AppEvents.learnDashboardBannerClick,
                              //     data: {});
                              openCtaUrl();
                            },
                            child: PageView(
                              controller: _controller,
                              children: banners.map((banner) {
                                return Image.network(
                                  banner.imageUrl ?? '',
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                );
                              }).toList(),
                            ),
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
                            dotColor: colors.sliderInactiveDotColor),
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
