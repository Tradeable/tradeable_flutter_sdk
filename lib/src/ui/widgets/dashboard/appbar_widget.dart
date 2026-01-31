import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final VoidCallback? onBack;

  const AppBarWidget(
      {super.key, required this.title, required this.color, this.onBack});

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return AppBar(
      backgroundColor: color,
      title: Text(title, style: textStyles.mediumBold),
      centerTitle: false,
      titleSpacing: 0,
      actionsPadding: EdgeInsets.only(right: 10),
      leading: IconButton(
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(Icons.arrow_back, color: colors.backBtnColor)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
