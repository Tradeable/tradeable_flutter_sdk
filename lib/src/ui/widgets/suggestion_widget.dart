import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/models/kagr/suggestion_model.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class SuggestionWidget extends StatelessWidget {
  final SuggestionModel model;

  const SuggestionWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;

    return Container(
      decoration: BoxDecoration(
          color: colors.listBgColor, borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xffeef3d4),
            borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.content,
                      style:
                          textStyles.smallNormal.copyWith(color: Colors.black)),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff97144D)),
                    child: Text("Renew Now",
                        style:
                            textStyles.smallBold.copyWith(color: Colors.white)),
                  )
                ],
              ),
            ),
            Image.asset(
              "packages/tradeable_flutter_sdk/lib/assets/images/axis_learn_logo.png",
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
