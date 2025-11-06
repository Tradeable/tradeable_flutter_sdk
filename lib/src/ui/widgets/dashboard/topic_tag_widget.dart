import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("App Pages", style: textStyles.mediumBold),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tags.asMap().entries.map((entry) {
              final index = entry.key;
              final tag = entry.value;
              final cardColors = [
                const Color(0xffF9EBEF),
                const Color(0xffEBF0F9),
                const Color(0xffF9F1EB),
                const Color(0xffEFF9EB)
              ];
              final color = cardColors[index % cardColors.length];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () {
                    TradeableRightSideDrawer.open(
                      context: context,
                      drawerBorderRadius: 24,
                      body: TopicListPage(
                        tagId: tag.topicTagId,
                        onClose: () => Navigator.of(context).pop(),
                        showBottomButton: false,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(4)),
                    child: Text(tag.formattedName),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
