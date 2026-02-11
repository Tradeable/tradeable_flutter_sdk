import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tradeable_flutter_sdk/src/models/enums/page_types.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_list_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/tradeable_right_side_drawer.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class TopicTagWidget extends StatelessWidget {
  final String? source;
  const TopicTagWidget({super.key, this.source});

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final tags = PageId.values;
    final cardColors = [
      colors.courseCardColor3,
      colors.courseCardColor4,
      colors.courseCardColor1,
      colors.courseCardColor2
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quick links", style: textStyles.mediumBold),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < tags.length; i++)
              InkWell(
                onTap: () {
                  // TFS().onEvent(
                  //     eventName: AppEvents.quickLinkClick,
                  //     data: {"title": tags[i].formattedName});
                  TradeableRightSideDrawer.open(
                    context: context,
                    drawerBorderRadius: 24,
                    body: TopicListPage(
                      tagId: tags[i].topicTagId,
                      onClose: () => Navigator.of(context).pop(),
                      showBottomButton: false,
                      source: source,
                    ),
                  );
                  TFS().onEvent(eventName: "Traders_Learn_Visited", data: {
                    "source": source,
                    "module": "Quick Links",
                    "category": tags[i].formattedName,
                    "progress": "",
                    "entity_id": TFS().clientId ?? ""
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: cardColors[i % cardColors.length],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AutoSizeText(
                    tags[i].formattedName,
                    style: textStyles.smallNormal,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
