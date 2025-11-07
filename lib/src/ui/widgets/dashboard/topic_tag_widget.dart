import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tradeable_flutter_sdk/src/models/enums/page_types.dart';
import 'package:tradeable_flutter_sdk/src/ui/pages/topic_list_page.dart';
import 'package:tradeable_flutter_sdk/src/ui/widgets/tradeable_right_side_drawer.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';

class TopicTagWidget extends StatelessWidget {
  const TopicTagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final tags = PageId.values;
    final cardColors = [
      const Color(0xffF9EBEF),
      const Color(0xffEBF0F9),
      const Color(0xffF9F1EB),
      const Color(0xffEFF9EB),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("App Pages", style: textStyles.mediumBold),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < tags.length; i++)
              InkWell(
                onTap: () => TradeableRightSideDrawer.open(
                  context: context,
                  drawerBorderRadius: 24,
                  body: TopicListPage(
                    tagId: tags[i].topicTagId,
                    onClose: () => Navigator.of(context).pop(),
                    showBottomButton: false,
                  ),
                ),
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
