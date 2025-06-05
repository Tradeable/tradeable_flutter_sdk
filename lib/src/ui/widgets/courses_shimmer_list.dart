import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CoursesListShimmer extends StatelessWidget {
  const CoursesListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: ListView.builder(
            itemCount: 6,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return const CourseListItemShimmer();
            },
          ),
        )
      ],
    );
  }
}

class CourseListItemShimmer extends StatelessWidget {
  const CourseListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.borderColorSecondary)),
      child: Shimmer.fromColors(
        baseColor: colors.borderColorSecondary,
        highlightColor: colors.cardBasicBackground.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 16, width: 80, color: Colors.white),
            const SizedBox(height: 10),
            Container(height: 12, width: 60, color: Colors.white),
            const SizedBox(height: 6),
            Container(height: 12, width: 100, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
