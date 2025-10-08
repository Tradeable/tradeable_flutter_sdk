import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class WebinarsList extends StatefulWidget {
  const WebinarsList({super.key});

  @override
  State<StatefulWidget> createState() => _WebinarsList();
}

class _WebinarsList extends State<WebinarsList> {
  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Webinars", style: textStyles.mediumBold),
            Spacer(),
            Text("View all",
                style: textStyles.smallBold
                    .copyWith(color: colors.borderColorPrimary)),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_ios,
                size: 10, color: colors.borderColorPrimary),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          itemCount: 6,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return WebinarsListItem();
          },
        )
      ],
    );
  }
}

class WebinarsListItem extends StatelessWidget {
  const WebinarsListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      padding: const EdgeInsets.all(12),
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.borderColorSecondary),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14), color: Colors.black),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                "packages/tradeable_flutter_sdk/lib/assets/images/course_container_bg.png",
                height: 110,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Reference site about Lorem  Ipsum, giving information",
                        style: textStyles.mediumBold.copyWith(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.arrow_forward_ios, size: 14)
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    webinarInfo("20 Dec , Fri", Icons.calendar_month, context),
                    const SizedBox(width: 6),
                    webinarInfo("60 mins", Icons.timer_outlined, context),
                    Spacer(),
                    IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: Icon(Icons.notifications_none),
                        color: colors.borderColorPrimary)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget webinarInfo(String title, IconData icon, BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Row(
      children: [
        Icon(icon, color: colors.textColorSecondary, size: 16),
        SizedBox(width: 4),
        Text(title,
            style: textStyles.smallNormal
                .copyWith(color: colors.textColorSecondary))
      ],
    );
  }
}
