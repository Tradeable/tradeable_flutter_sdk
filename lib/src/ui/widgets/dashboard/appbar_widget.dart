import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/tfs.dart';
import 'package:tradeable_flutter_sdk/src/utils/app_theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textStyles =
        TFS().themeData?.customTextStyles ?? Theme.of(context).customTextStyles;
    final colors =
        TFS().themeData?.customColors ?? Theme.of(context).customColors;

    return AppBar(
      backgroundColor: colors.background,
      title: Text(title, style: textStyles.mediumBold),
      titleSpacing: 0,
      actionsPadding: EdgeInsets.only(right: 10),
      actions: [Icon(Icons.account_circle_outlined)],
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
