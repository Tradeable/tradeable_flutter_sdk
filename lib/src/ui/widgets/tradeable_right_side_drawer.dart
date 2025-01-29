import 'package:flutter/material.dart';

class TradeableRightSideDrawer {
  static Future<dynamic> open(
      {required BuildContext context,
      required Widget body,
      double? width,
      String barrierLabel = "Learn Sheet",
      bool barrierDismissible = true,
      Color barrierColor = const Color(0x66000000),
      double drawerBorderRadius = 0,
      Color drawerColor = Colors.white,
      Duration transitionDuration = const Duration(milliseconds: 300)}) async {
    dynamic data = await _showDrawerSide(
      context: context,
      body: body,
      width: width,
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      drawerBorderRadius: drawerBorderRadius,
      drawerColor: drawerColor,
      transitionDuration: transitionDuration,
    );
    if (data == null) return '';

    return data;
  }

  static _showDrawerSide({
    required BuildContext context,
    required Widget body,
    double? width,
    required String barrierLabel,
    required bool barrierDismissible,
    required Color barrierColor,
    required double drawerBorderRadius,
    required Color drawerColor,
    required Duration transitionDuration,
  }) {
    BorderRadius borderRadius = BorderRadius.only(
      topLeft: Radius.circular(drawerBorderRadius),
      bottomLeft: Radius.circular(drawerBorderRadius),
      topRight: Radius.zero,
      bottomRight: Radius.zero,
    );

    return showGeneralDialog(
      barrierLabel: barrierLabel,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            elevation: 15,
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: Container(
                decoration: BoxDecoration(
                    color: drawerColor, borderRadius: borderRadius),
                height: double.infinity,
                width: width ?? MediaQuery.of(context).size.width - 32,
                child: body),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
              .animate(animation1),
          child: child,
        );
      },
    );
  }
}
