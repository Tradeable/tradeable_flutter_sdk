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

    return AppBar(
      backgroundColor: color,
      title: Text(title, style: textStyles.mediumBold),
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
          icon: Icon(Icons.arrow_back)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
