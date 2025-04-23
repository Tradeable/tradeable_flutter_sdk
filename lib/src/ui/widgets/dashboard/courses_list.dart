import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class CoursesList extends StatefulWidget {
  const CoursesList({super.key});

  @override
  State<StatefulWidget> createState() => _CoursesList();
}

class _CoursesList extends State<CoursesList> {
  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Column(
      children: [
        Row(
          children: [
            Text("Courses", style: textStyles.mediumBold),
            Spacer(),
            Row(
              children: [
                Text("View all",
                    style: textStyles.smallBold
                        .copyWith(color: colors.borderColorPrimary)),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward_ios,
                    size: 10, color: colors.borderColorPrimary)
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
              itemCount: 6,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return CourseListItem();
              }),
        )
      ],
    );
  }
}

class CourseListItem extends StatelessWidget {
  const CourseListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  "packages/tradeable_flutter_sdk/lib/assets/images/course_container_bg.png"),
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.borderColorSecondary)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text("Courses", style: textStyles.mediumBold)),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_ios,
                  size: 14, color: colors.borderColorPrimary)
            ],
          ),
          const SizedBox(height: 6),
          Text("10 Topics | 30m")
        ],
      ),
    );
  }
}
